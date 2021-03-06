function m=get_tog16_feature(objfolder,matpath)

    S_mtx=[];
    objlist=dir([objfolder,'\*.obj']);
    [~,i]=sort_nat({objlist.name});
    objlist=objlist(i);
    if ~exist([objfolder,'\new'],'file')
        mkdir([objfolder,'\new']);
    end
    for i= 1:size(objlist,1)
        copyfile([objfolder,'\',objlist(i).name],[objfolder,'\new\',num2str(i),'.obj'],'f');
    end
    
    if nargin < 2
        matpath=[objfolder,'\new'];
    end
    if exist([matpath,'\tog16_point_edge.mat'],'file')
        return
    end
    objlist=dir([objfolder,'\new\*.obj']);
    [~,i]=sort_nat({objlist.name});
    objlist=objlist(i);
    if ~exist([objfolder,'\fv.mat'],'file') && ~exist([objfolder,'\new\fv.mat'],'file')
        GetFeature([objfolder,'\new'],size(objlist,1));
    end
    if exist([objfolder,'\fv.mat'],'file')
    fv=load([objfolder,'\fv.mat']);
    end
    if exist([objfolder,'\new\fv.mat'],'file')
    fv=load([objfolder,'\new\fv.mat']);
    end
    
    
    [ fmlogdr, fms ] = FeatureMap( fv.LOGDR, fv.S );
    S_matrix_minus=sparse([1:size(fv.eidmap,1)]',fv.eidmap(:,1)+1,-ones(size(fv.eidmap,1),1));
    S_matrix_plus=sparse([1:size(fv.eidmap,1)]',fv.eidmap(:,2)+1,ones(size(fv.eidmap,1),1));
    S_matrix=S_matrix_minus+S_matrix_plus;
    S_matrix=kron(S_matrix,eye(9));
    S_mtx.S_matrix=S_matrix;
    S_mtx.eidmap=fv.eidmap;
    fmlogdr=permute(reshape(fmlogdr,size(fmlogdr,1),3,size(fv.eidmap,1)),[1,3,2]);
    fms=permute(reshape(fms,size(fms,1),6,size(fms,2)/6),[1,3,2]);

    m=matfile([matpath,'\tog16_point_edge.mat'],'writable',true);
    m.logdr=fmlogdr;
    m.s=fms;
    [v,~,~,~,~,vv,~,~,~,b_E,e2v] = cotlp([objfolder,'\new\',objlist(1).name]);
    p_neighbour=zeros(size(v,1),100);
    maxnum=0;
    for i=1:size(vv,1)
        p_neighbour(i,1:size(vv{i,:},2))=vv{i,:};
        if size(vv{i,:},2)>maxnum
            maxnum=size(vv{i,:},2);
        end
    end
    p_neighbour(:,maxnum+1:end)=[];
    e2v_=e2v(:,[2,1]);
    e2vall=[e2v;e2v_];
    id=knnsearch(e2vall,fv.eidmap);
    idx=find(id>size(e2v,1));
    id(idx)=id(idx)-size(e2v,1);
    e_neighbour=b_E(id,:);
    e_neighbour(:,1)=[];
    m.e_neighbour=e_neighbour;
    m.p_neighbour=p_neighbour;
    m.e_adj = neighbour2adj(m.e_neighbour);
    m.p_adj = neighbour2adj(m.p_neighbour);
    %m.Smtx=S_mtx;
end