%------------------------------------------------------------------------------------------------------------------------------------
%%%   Volumetrical-mapping design of origami architected materials   
%-------------------------------------------------------------------------------------------------------------------------------------
% This code generates prismatic architected materials with a given shape, e.g., sphere, cone, spindle, pyramid
% Writtern by Kai Xiao
% Tested in MALTAB 2021a  
% For any questions, please send message to kaixiao55@gmail.com

clear, close all
 
%  Construct template with multiple polyhedron %
%---------------------------------------------------------------------------------------------------------
%  Select template %
scaleValue=1/2;                % Default option 
opt.template='#23';           % initial unit cell  selection (28 different spatial tessellations in total)
opt.tessellation='on';     % this option means the if the template are tessellated or justed single basic unit; if it is on, user may want specify system size (opt.tesellateLoc)
opt.deform='on';              % Activate mapping 
opt.deformMode='omt_Sphere'; %Options: 'omt_Cylinder', 'omt_spind', 'omt_cone', 'omt_helix', 'omt_pyramid','omt_Sphere'; 'dir_Sphere' this uses optimal transport to get targetting shape
opt.templatePBC='off';  % Don't use it
% opt.manuDisconnected='off';     % Manully disconnect some tube from extrusion 
opt.optimizeInterPoly='off';        % Don't use it
opt.saveAll='off';
% ---------------------- Size size ------------------------------------------------------------------
opt.tesellateLoc=[2 2 2];    % not all system size have mapped data in this code;  check the attached folder for avaiable data files with different system size of mapping
opt.removePolyBeforeExtrusion='off'; % option for build partial-filling tessellation
% ----------------------------------------------------------------------------------------------------
opt.extrudNormalSomeFace='off';   % after activatng this, the template can normally extrude the face which does not belong to facepair
% ---------------- option for enhance reconfigurability after full extrusion ---------------
opt.onlyInnerFacePair='off';
opt.removePoly='off'; % partial filling option
opt.deleteFacePair='off'; % Don't use it
opt.deleteSingleFace='off'; % stop extuding face option: opt.deSFpIdx=[f p]; where index denotes f-th face on p-th polyhedron ;
% -----------------------------------------
opt.MergeCommonEdge='off'; 
% -----------------------------------------
opt.remPidx=[];     opt.deSFpIdx=[];
if strcmp(opt.deleteSingleFace,'off')==1
    opt.deSFpIdx=[0 0];
end
%---------------------------------------------------------------------------------------------------------
[unitCell]=SelectTemplate(opt);
[unitCell]=AlterPositionPolyhedra(unitCell);  % alter position of polyhedra as defined by user (Writtern by Dr. Bas Overvelde)
[unitCell]=FindGlobalIndex(unitCell);
if length(unitCell.Polyhedron)>1
    [unitCell.GeTemGlobal.node,unitCell.GeTemGlobal.edge,unitCell.GeTemGlobal.face,~]=mergeNodeAdvance(unitCell.GeTemGlobal.node,unitCell.GeTemGlobal.edge,unitCell.GeTemGlobal.face,[]);
end

%---------------------------------------------------------------------------------------------------------
%  Tessellate along lattice direction  Find lattice vectors of unit cell
for i=1: size(unitCell.perCon,1)
    gloFace1= unitCell.Polyhedron(unitCell.perCon(i,3)).face{unitCell.perCon(i,1)};
    gloFace2= unitCell.Polyhedron(unitCell.perCon(i,4)).face{unitCell.perCon(i,2)};
    unitLV0(i,:)=(sum(unitCell.Polyhedron(unitCell.perCon(i,3)).node(gloFace1,:))-sum(unitCell.Polyhedron(unitCell.perCon(i,4)).node(gloFace2,:)))./length(gloFace1);
end
[unitLV,~]=findAllLatticeVectorsCombination(unitLV0); 
if strcmp(opt.tessellation,'on')==1  
    % Tessellate along lattice vectors' direction
    for i=1:length(opt.tesellateLoc)
        globalLv0(i,:)=opt.tesellateLoc(i)*unitLV0(i,:);
    end
    % Construct the global lattice vector and information for global assemble
    unitCell.assemPerCon=unitCell.perCon;
    [tessellateLayout]=findLayoutPosition(unitLV0,opt.tesellateLoc);
    if strcmp(opt.removePolyBeforeExtrusion,'on')==1
        tessellateLayout(opt.PreRemPidx,:)=[];
    end
    unitCell.assemPerCon(1,3)=unitCell.assemPerCon(1,3)+(opt.tesellateLoc(1)-1)*length(unitCell.Polyhedron);
    unitCell.assemPerCon(2,3)=unitCell.assemPerCon(2,3)+(opt.tesellateLoc(1)*(opt.tesellateLoc(2)-1)+1)*length(unitCell.Polyhedron);
    unitCell.assemPerCon(3,3)=unitCell.assemPerCon(3,3)+(opt.tesellateLoc(1)*opt.tesellateLoc(2)*(opt.tesellateLoc(3)-1))*length(unitCell.Polyhedron);
    
    [unitCell.GeTemGlobal]=assembleSeemless(unitCell.GeTemGlobal,tessellateLayout);
    %---------------------------------------------------------------------------------------------------------
    % Merge nodes
    [unitCell.GeTemGlobal.node,...
        unitCell.GeTemGlobal.edge,...
        unitCell.GeTemGlobal.face,~]=mergeNodeAdvance(unitCell.GeTemGlobal.node,unitCell.GeTemGlobal.edge,unitCell.GeTemGlobal.face,[]);
    % delete overlapping Global face
    [globalLv,~]=findAllLatticeVectorsCombination(globalLv0); %  test
    globalLvDe=globalLv0;
    globalLvEx=globalLv;
else
    tessellateLayout=[];
    globalLvEx=unitLV;   
    globalLvDe=unitLV0; 
end
viewPoint=unitCell.ViewPoint;
if strcmp(opt.tessellation,'on')==1
   [unitCell]=reArrangePoly(unitCell, tessellateLayout);
    [unitCell]=LocIndexUpdatedCoo(unitCell);
else  % if the template does not need tessellation
    unitCell.GloPolyhedron=unitCell.Polyhedron;    unitCell.locPolyhedron=unitCell.Polyhedron;
end

figure
unitCell.unDePolyhedron=unitCell.locPolyhedron;
Plot(unitCell.locPolyhedron,viewPoint,'texxt','ftexxt','polyhedra',4,length(unitCell.Polyhedron),1)
title('Selected unit cells in system size')
% Find face pair for further extrusion before deforming the template
[unitCell]=findFacePairOfTemplate(unitCell,globalLvEx,opt); 
[unitCell]=findGloLvInfoFROMAssembleTemp(unitCell,globalLvDe);

%---------------------------------------------------------------------------------------------------------
%  targetting shapes
if strcmp(opt.deform,'on')==1
    switch opt.deformMode
        case 'omt_Cylinder'
            addpath('omt_cylinder template')
            load([opt.template,'_',num2str(opt.tesellateLoc),'_restored','.mat'],'rePoly');
            unitCell.GeTemGlobal.node=rePoly.node;
        case 'omt_ring'
            addpath('omt_ring template')
            load([opt.template,'_',num2str(opt.tesellateLoc),'_restored','.mat'],'rePoly');
            unitCell.GeTemGlobal.node=rePoly.node;
        case 'omt_spind'
            addpath('omt_spind template')
            load([opt.template,'_',num2str(opt.tesellateLoc),'_restored','.mat'],'rePoly');
            unitCell.GeTemGlobal.node=rePoly.node;
        case 'omt_cone'
            addpath('omt_cone template')
            load([opt.template,'_',num2str(opt.tesellateLoc),'_restored','.mat'],'rePoly');
            unitCell.GeTemGlobal.node=rePoly.node;
        case 'omt_helix'
            addpath('omt_Helix template')
            load([opt.template,'_',num2str(opt.tesellateLoc),'_restored','.mat'],'rePoly');
            unitCell.GeTemGlobal.node=rePoly.node;
        case 'omt_Sphere'
            addpath('omt_Spherical template/Graphite')
            load([opt.template,'_',num2str(opt.tesellateLoc),'_restored','.mat'],'rePoly');
            unitCell.GeTemGlobal.node=rePoly.node;
        case 'omt_cube'
            addpath('omt_cube template')
            load([opt.template,'_',num2str(opt.tesellateLoc),'_restored','.mat'],'rePoly');
            unitCell.GeTemGlobal.node=rePoly.node;
        case 'dir_Sphere'
           addpath('omt_Spherical template')
            if isequal(opt.tesellateLoc,[2 2 2])
               SphericalUnitCell=load([opt.template,'_',num2str(opt.tesellateLoc),'_restored','.mat'],'Map');
               unitCell.GeTemGlobal.node=SphericalUnitCell.Map.node;
            elseif  isequal(opt.tesellateLoc,[3 3 3])
                load([opt.template,'_',num2str(opt.tesellateLoc),'_B','.mat'],'InitialUnitCell'); %normal set
                % find nearst node
                idx=knnsearch( InitialUnitCell.node,unitCell.GeTemGlobal.node);  %normal set
                SphericalUnitCell=load([opt.template,'_',num2str(opt.tesellateLoc),'_B','.mat'],'Map');          %normal set
                unitCell.GeTemGlobal.node=SphericalUnitCell.Map.node(idx,:);            %normal set
            end
        case 'omt_pyramid'
            addpath('omt_Pyramid template')
            load([opt.template,'_',num2str(opt.tesellateLoc),'_restored','.mat'],'rePoly');
            unitCell.GeTemGlobal.node=rePoly.node;
    end
    [unitCell]=reArrangePoly(unitCell, tessellateLayout);    [unitCell]=LocIndexUpdatedCoo(unitCell);
end
%------------------------------------------------------------------
% option for stopping extruding faces
if strcmp(opt.deleteFacePair,'on')==1
    [unitCell.facepair]=deleteFacePair(unitCell.facepair,opt.deFpIdx);
end

%---------------------------------------------------------------------------------------------------------
% Extrusion function
%---------------------------------------------------------------------------------------------------------
[exMetaMaterials.Polyhedron,unitCell]=Extrusion(unitCell,scaleValue,1,opt);
[exMetaMaterials.Polyhedron]=findEdge(exMetaMaterials.Polyhedron);
figure
Plot(unitCell.locPolyhedron, viewPoint,'texxt','ftxext','polyhedra',4,length(unitCell.Polyhedron),1)
title('The Template')
% if strcmp (opt.tessellation,'on')==1
%     [cycles,cnect]=PlotLoops(unitCell.locPolyhedron,unique(sort(unitCell.innerFacePair(:,3:4),2),'rows'),opt.deSFpIdx, opt.remPidx, unitCell.innerFacePair, viewPoint,'yes');
%     unitCell.adjactList=cnect;
% end
figure
Plot(unitCell.interPolyhedron,viewPoint,'texxt','ftexxt','polyhedra',4,length(unitCell.Polyhedron),0.3)  
% hold on
%  [cycles,cnect]=PlotLoops(unitCell.locPolyhedron,unique(sort(unitCell.innerFacePair(:,3:4),2),'rows'),opt.deSFpIdx, opt.remPidx, unitCell.innerFacePair, viewPoint,'No');
title('Scaled Template')
%----------------------------- delete some unit -----------------------------
exMetaMaterials.Polyidx=1:length(exMetaMaterials.Polyhedron);
if strcmp(opt.removePoly,'on')==1
    exMetaMaterials.Polyidx(opt.remPidx)=[];
    exMetaMaterials.Polyhedron(opt.remPidx)=[];
end
%  Find Gobal index and merge node
[exMetaMaterials]=FindGlobalIndex(exMetaMaterials);

[exMetaMaterials.GeTemGlobal.node,...
    exMetaMaterials.GeTemGlobal.edge,...
    exMetaMaterials.GeTemGlobal.face,...
    exMetaMaterials.GeTemGlobal.hingeEx]=mergeNodeAdvance(exMetaMaterials.GeTemGlobal.node,exMetaMaterials.GeTemGlobal.edge,exMetaMaterials.GeTemGlobal.face,exMetaMaterials.GeTemGlobal.hingeEx);
% if it is partially extruded
[exMetaMaterials.GeTemGlobal.node,exMetaMaterials.GeTemGlobal.face,exMetaMaterials.GeTemGlobal.edge,exMetaMaterials.GeTemGlobal.hingeEx]=...
    reNumberPartialFaceSnapology(exMetaMaterials.GeTemGlobal.node,exMetaMaterials.GeTemGlobal.face,exMetaMaterials.GeTemGlobal.edge,exMetaMaterials.GeTemGlobal.hingeEx);

for i=1:length(exMetaMaterials.Polyhedron)
    [exMetaMaterials.Polyhedron(i).node,...
        exMetaMaterials.Polyhedron(i).edge,...
        exMetaMaterials.Polyhedron(i).face,...
        exMetaMaterials.Polyhedron(i).hingeEx]=mergeNodeAdvance(exMetaMaterials.Polyhedron(i).node,exMetaMaterials.Polyhedron(i).edge,exMetaMaterials.Polyhedron(i).face,exMetaMaterials.Polyhedron(i).hingeEx);
    [IdiviMobility(i),~]=CalMobility(exMetaMaterials.Polyhedron(i).node, exMetaMaterials.Polyhedron(i).face,...
        exMetaMaterials.Polyhedron(i).edge);
end
% title(strcat('DOF=', mat2str(mobility)));
figure
Plot(exMetaMaterials.Polyhedron,viewPoint,'textx','ftexxt','Snapology',4,length(unitCell.Polyhedron),1)

set(gcf,'unit','centimeters','position',[3 2 43 28])
title('Origami architected materials with a target shape')
lim.ex_Xlim=get(gca,'xlim');   lim.ex_Ylim=get(gca,'ylim');    lim.ex_Zlim=get(gca,'zlim');

%---------------------------------------------------------------------------------------------------------
% For assembly the architected materials
if strcmp(opt.MergeCommonEdge,'on')==1
 [ exMetaMaterials.GeTemGlobal.face, exMetaMaterials.GeTemGlobal.hingeEx]=mergeCommonEdgeOnFace( exMetaMaterials.GeTemGlobal);
 [exMetaMaterials.GeTemGlobal.node,exMetaMaterials.GeTemGlobal.face,exMetaMaterials.GeTemGlobal.edge,exMetaMaterials.GeTemGlobal.hingeEx]=...
    reNumberPartialFaceSnapology(exMetaMaterials.GeTemGlobal.node,exMetaMaterials.GeTemGlobal.face,exMetaMaterials.GeTemGlobal.edge,exMetaMaterials.GeTemGlobal.hingeEx);

figure
Plot(exMetaMaterials.GeTemGlobal,viewPoint,'textx','ftexxt','Snapology',4,length(unitCell.Polyhedron),1)
set(gcf,'unit','centimeters','position',[3 2 43 28])
end
if strcmp(opt.saveAll,'on')==1
    if strcmp(opt.deform,'on')==1
        save([opt.template,'_',num2str(tesellateLoc),'_',opt.deformMode,'.mat'])
    else
        save([opt.template,'_',num2str(tesellateLoc),'.mat'])
    end
end


%---------------------------------------------------------------------------------------------------------
%%%%%%%%%%%%%    Sub-Functions   %%%%%%%%%%%%%%%%%%%
%---------------------------------------------------------------------------------------------------------
function [fp]=deleteFacePair(fp,deFpIdx)
for i=1:size(deFpIdx,1)
    %     deFpIdx(i,:)
    [la1,la2]=ismember(deFpIdx(i,:),fp(:,3:4),'rows');
    [lb1,lb2]=ismember(fliplr(deFpIdx(i,:)),fp(:,3:4),'rows');
    if la1 || lb1 ==1
        if la1 ==1
            fp(la2,:)=[];
        elseif lb1 ==1
            fp(lb2,:)=[];
        end
    end
end
end

 function [newNode,newFace,newEdge,newHingex]=reNumberPartialFaceSnapology(node,face,edge,hingeEx)
faceNode=[];
for i=1:size(face,1)
    faceNode=[faceNode;face{i},];
end
newNodeIdx=unique(faceNode);
newFace=face; newNode=node(newNodeIdx,:);
% re-number the face
for i=1:size(face,1)
    for j=1:length(face{i})
        newFace{i}(j)=find(newNodeIdx==face{i}(j));
    end
end
Ne=1;
for i=1:size(edge,1)
    if isempty( find(newNodeIdx==edge(i,1), 1))==0
        for j=1:length(edge(i,:))
            if isempty( find(newNodeIdx==edge(i,j), 1))==0
                newEdge(Ne,j)=find(newNodeIdx==edge(i,j));
                if j==length(edge(i,:))
                    Ne=Ne+1;
                end
            else 
                break
            end
        end
    end
end
Nh=1;
for i=1:size(hingeEx,1)
   if  isempty( find(newNodeIdx==hingeEx(i,1), 1))==0
    for j=1:length(hingeEx(i,:))
        if  isempty( find(newNodeIdx==hingeEx(i,j), 1))==0
        newHingex(Nh,j)=find(newNodeIdx==hingeEx(i,j));
         if j==length(hingeEx(i,:))
            Nh=Nh+1;
         end
        else
            break
        end
    end
    end
end
   end

function [layPos]=findLayoutPosition(Lav,layout)
m=1;
for k=1:layout(3)
    for j=1:layout(2)
        for i=1:layout(1)
            layPos(m,:)=[0 0 0]+(i-1)*Lav(1,:)+(j-1)*Lav(2,:)+(k-1)*Lav(3,:);
            m=m+1;
        end
    end
end
layPos(1,:)=[];
end


function [C,B]=findAllLatticeVectorsCombination(A)
x1=[-1 0 1];    x2=x1;    x3=x2;
[x3,x2,x1] = ndgrid(x3,x2,x1);
B=[x1(:) x2(:) x3(:)];
B(all(B==0,2),:)=[];
for i=1:size(B,1)
    C(i,:)=B(i,1)*A(1,:)+B(i,2)*A(2,:)+B(i,3)*A(3,:);
end
end

%  Find a PBC's information expressed by node in a assembled template
function [unitCell]=findGloLvInfoFROMAssembleTemp(unitCell,globalLv)
node=unitCell.GeTemGlobal.node;
for i=1:size(globalLv,1)
    for j=1:size(node,1)
        for k=1:size(node,1)
            if i~=k
                if norm(node(j,:)+globalLv(i,:)-node(k,:))<1e-8
                    unitCell.LvInfo(i,:)=[k j;];
                    %                     m=m+1;
                end
            end
        end
    end
end
end

function [unitCell]=findFacePairOfTemplate(unitCell,globalLv,opt)
%  this function uses undeformed template, and lattice vector to find the face pair matrix in terms of
%  [f1 f2 p1 p2], including internal tethered face pair and face pair of PBC
%  input is unitCell.locPolyhedron output is unitCell.facePair
% Step #1: find face center vector
for i=1:length(unitCell.locPolyhedron)
    for j=1:length(unitCell.locPolyhedron(i).face)
        faceindex=unitCell.locPolyhedron(i).face{j};
        unit(i).faceCenterVector(j,:)=sum(unitCell.locPolyhedron(i).node(faceindex,:))/size(unitCell.locPolyhedron(i).node(faceindex,:),1);
    end
end
% Step #2: find face pair
facePair2=[];  PBCfacePair2=[];
% -------------------------------------------------------
fCV=[];   fCVidx=[];
% find face center vector
for i=1:length(unit)
    for j=1:size(unit(i).faceCenterVector,1)
        fCV=[fCV; unit(i).faceCenterVector(j,:)];  % fCV [v1 v2 v3 i-th unit, j-th face]
        fCVidx=[ fCVidx; i j ];
    end
end
% find face pair bonding together
% ----------------------------- k=2 knn search ----------------------------------
fCV2=fCV;
IdxNN1 = knnsearch(fCV2,fCV,'K',2);
for i=1:size(IdxNN1,1)
    nearestNodeidx(i)=IdxNN1(i,IdxNN1(i,:)~=i);
    nearestNode(i,:)=fCV2(nearestNodeidx(i),:);
    if norm(nearestNode(i,:)-fCV(i,:))<1e-9
        p1=fCVidx( nearestNodeidx(i), 1);   f1=fCVidx( nearestNodeidx(i),2);  p2=fCVidx(i,1);  f2=fCVidx(i,2);
        facePair2=[facePair2; f1 f2 p1 p2 ];
    end
end
% -----------------------------------------------------------------------------------
for q=1:size(globalLv,1)
    pbcfCV=fCV+globalLv(q,:);
    IdxNN2 = knnsearch(fCV,pbcfCV);
    for i=1:size(IdxNN2,1)
        if norm(pbcfCV(i,:)-fCV(IdxNN2(i),:))<1e-9
            PBCfacePair2=[PBCfacePair2;  [fCVidx(IdxNN2(i),2)   fCVidx(i,2)  fCVidx(IdxNN2(i),1)  fCVidx(i,1) ] ];
        end
    end
end
%  ------------------------------------ ------------------------------------ ------------------------------------
if  isempty(facePair2)~=1 % facepair has element
    % --------------------  Previous calculation of unitCell.facePair   -------------------
    %     [~, ia ,~]=unique(sort(facePair2,2),'rows');   % previous settting %     Sep.11th
    %     unitCell.facepair=facePair2(ia,:);   % previous settting      Sep.11th
    unitCell.facepair=deleteOverplappedFacePair(facePair2);   %  new setting
    [~,I1]=sort(unitCell.facepair(:,1),1);
    unitCell.facepair=unitCell.facepair(I1,:);
    unitCell.PBCpairLocIndex=size(unitCell.facepair,1);
else
    unitCell.facepair=[];
    unitCell.PBCpairLocIndex=0;
end
% --------------------  Previous calculation of unitCell.PBCfacePair   -------------------
unitCell.PBCfacePair=PBCfacePair2;
[~,I2]=sort(unitCell.PBCfacePair(:,1),1);
unitCell.PBCfacePair=unitCell.PBCfacePair(I2,:);
[unitCell.PBCfacePair]=deleteOverplappedFacePair(unitCell.PBCfacePair);
% --------------------
% below rows control the outer extrusion
unitCell.innerFacePair=unitCell.facepair;
if strcmp(opt.onlyInnerFacePair,'on')~=1
    unitCell.facepair=[unitCell.facepair; unitCell.PBCfacePair];
end
% [unitCell.facepair]=deleteOverplappedFacePair(unitCell.facepair);
% Find Boundary Face
bordFace=[];
if isempty(unitCell.innerFacePair)==0
    for p=1:length(unitCell.locPolyhedron)
        pc=[];  pc2=[];
        [pc,~]=find(unitCell.innerFacePair(:,3)==p);
        [pc2,~]=find(unitCell.innerFacePair(:,4)==p);
        if isempty(pc)==0  ||   isempty(pc2)==0
            innerFaceP=[unitCell.innerFacePair(pc,1)'  unitCell.innerFacePair(pc2,2)' ];
            totalFace=[1:1:size(unitCell.locPolyhedron(p).face,1)];
            totalFace(innerFaceP)=[];
            bordFace=[bordFace; [totalFace', p*ones(length(totalFace),1)] ];
        end
    end
    unitCell.borderFace=bordFace;
end
% Last step: find vertice pair on the facepair  
% uniCell.verPairFace{fcepair-th}=[p1_v1  p1_pv2 p1_pv3 p1_pv4 ;  p2_v1  p2_pv2 p2_pv3 p2_pv4 ;]
% input: unitCell.facepair;    unitCell.locPolyhedorn;
% log of change: 2022-08-15 adding PBC vertpos1
for fp=1:size(unitCell.facepair,1)
    f1=unitCell.facepair(fp,1);   f2=unitCell.facepair(fp,2);   p1=unitCell.facepair(fp,3);   p2=unitCell.facepair(fp,4);
    verIdxf1=unitCell.locPolyhedron(p1).face{f1};  verIdxf2=unitCell.locPolyhedron(p2).face{f2};
    if strcmp(opt.onlyInnerFacePair,'on')~=1
        if fp>unitCell.PBCpairLocIndex
            vertpos1=unitCell.locPolyhedron(p1).node(verIdxf1,:);    vertpos2=unitCell.locPolyhedron(p2).node(verIdxf2,:);
            reCenter1=sum(vertpos2,1)/length(verIdxf2)-sum(vertpos1,1)/length(verIdxf1);
            vertpos1=vertpos1+reCenter1;
        else
             vertpos1=unitCell.locPolyhedron(p1).node(verIdxf1,:);    vertpos2=unitCell.locPolyhedron(p2).node(verIdxf2,:);
        end
    else
        vertpos1=unitCell.locPolyhedron(p1).node(verIdxf1,:);    vertpos2=unitCell.locPolyhedron(p2).node(verIdxf2,:);
    end
    IdxVV = knnsearch(vertpos2,vertpos1);
    unitCell.verPairFace{fp}=[verIdxf1; verIdxf2(IdxVV)];
end
end

function [a]=deleteOverplappedFacePair(a)
%  Delete overlapping ones
k=1;
for i=1:size(a,1)
    test=[a(i,2) a(i,1) a(i,4) a(i,3) ];
    if ismember(test,a(1:i,:),'rows')==1
        index(k)=i;
        k=k+1;
    end
end
a(index,:)=[];
end
% Assemble all information (node, face ,edge together)
function [GeTemGlobal]=assembleSeemless(GeTemGlobal,tessellateLayout)
nNode2=size(GeTemGlobal.node,1);   nFace2=size(GeTemGlobal.face,1);   nEdge2=size(GeTemGlobal.edge,1);
for i=1:size(tessellateLayout,1)
    GeTemGlobal.node(i*nNode2+1:(i+1)*nNode2, :)=GeTemGlobal.node(1:nNode2,:)+tessellateLayout(i,:);
    for j=1:nFace2
        GeTemGlobal.face{i*nFace2+j, 1}=GeTemGlobal.face{j,1}+i*nNode2;
        
    end
    GeTemGlobal.edge(i*nEdge2+1:(i+1)*nEdge2, :)=GeTemGlobal.edge(1:nEdge2,:)+i*nNode2;
end
end

% Extrusion function
function [exMetaMaterials,unitCell]=Extrusion(unitCell,scaleValue,optExlength,opt)
for i=1:length(unitCell.locPolyhedron)  % Scaling polyhedron
    bodyCenter(i,:)=sum(unitCell.locPolyhedron(i).node)/size(unitCell.locPolyhedron(i).node,1);
    unitCell.interPolyhedron(i).node=scaleValue*(unitCell.locPolyhedron(i).node-bodyCenter(i,:))+bodyCenter(i,:);
    unitCell.interPolyhedron(i).face=unitCell.locPolyhedron(i).face;
    unitCell.interPolyhedron(i).edge=unitCell.locPolyhedron(i).edge;
end
% figure
% Plot(unitCell.interPolyhedron,unitCell.ViewPoint,'texxt','ftext','polyhedra',4,length(unitCell.Polyhedron),0.3)  

for j=1:length(unitCell.locPolyhedron)
    % Find which face pair of j-th polyhedron needs to be extruded
    [row,col]=find(unitCell.facepair(:,3:4)==j);  %  loop every polyhedron
    faceidxPair=[];
    for id=1:length(row)
        faceidxPair=[faceidxPair, unitCell.facepair(row(id),col(id))];  % find all idx of the face in the facePair
    end
    % Preparing Extrusion
    exMetaMaterials(j).node=unitCell.interPolyhedron(j).node;
    exMetaMaterials(j).face{1}=[];  %  set the initial values
    exMetaMaterials(j).hingeEx(1,:)=[0 0 0 0];   %  set the initial values
    %  ----------------------------- start extrusion ---------------------------
    [jpoly,~]=ismember(j,opt.deSFpIdx(:,2));
    for k=1:length(unitCell.locPolyhedron(j).face) % k-th face pair to extrude in j-th polyhedron
        %  ----------------------------- option for stopping extrusion----------
        if ismember(k,opt.deSFpIdx(opt.deSFpIdx(:,2)==j,1))~=1 || jpoly~=1 % if current findex-th face and j-th polyhedron are not in the deletion list
            %  -----------------------------
            if ismember(k,faceidxPair)==1   % for those faces' extrusion can be determinded by facepair
                [row2,col2]=find(unitCell.facepair(:,3:4)==j & unitCell.facepair(:,1:2)==k);
                if col2==1
                    findex=unitCell.facepair(row2,1);    % face index of j-th polyhedron on k-th face pair
                    PolyIndex=unitCell.facepair(row2,4);   % Polyindex means the other polyhedron which pairs with j-th polyhedron
                    findexPair=unitCell.facepair(row2,2);
                    nodePair=2; % corresponds the second row of unitCell.verPairFace
                elseif col2==2
                    findex=unitCell.facepair(row2,2);    % face index of j-th polyhedron on k-th face pair
                    PolyIndex=unitCell.facepair(row2,3);
                    findexPair=unitCell.facepair(row2,1);
                    nodePair=1; %
                end
                %  -----------------------------------------------------------------------------
                nodex=unitCell.locPolyhedron(j).face{findex};  % currrect extruding nodes index on face
                nodexPair=unitCell.locPolyhedron(PolyIndex).face{findexPair};    %  the corresponding face and node index
                %  find extrusion direction, where obt is a vector that connects face pair's center point
                nodePairIdx=[];
                 for ndx=1:length(nodex)
                     nodePairIdx(ndx)=unitCell.verPairFace{row2}(nodePair,unitCell.verPairFace{row2}(col2,:)==nodex(ndx));
                 end
                 obt{j,k}(1:length(nodex),:)=-(unitCell.interPolyhedron(j).node(nodex,:)-unitCell.interPolyhedron(PolyIndex).node(nodePairIdx,:))/2;    
                 PBCfaceidxPair=[];
                if isempty(unitCell.PBCfacePair)==0
                    [row3,col3]=find(unitCell.PBCfacePair(:,3:4)==j);
                    for id=1:length(row3)
                        PBCfaceidxPair=[PBCfaceidxPair, unitCell.PBCfacePair(row3(id),col3(id))];  % find all idx of the face in the facePair
                    end
                end
                % ------------   determine the extrusion direction according to differnent template and face pair
                if  ismember(k,PBCfaceidxPair)==1  
                    for bEx=1:length(nodex)
%                         if strcmp(opt.extrudNormalSomeFace,'on')==1
                       BexVect=sum(unitCell.locPolyhedron(j).node(nodex,:),1)/length(nodex)-...
                           sum(unitCell.interPolyhedron(j).node(nodex,:),1)/length(nodex);
                       obt{j,k}(bEx,:)=BexVect;
                    end
                end
                for enex=1:length(nodex)
                    exl{j,k}(enex,:)=obt{j,k}(enex,:);
                end
            end
            %-----------------------------------------------------------------------
            % extrusion : note the numbering of index for nodes on each face should be anti-clock wise direction
            if  ismember(k,faceidxPair)==1 || strcmp(opt.extrudNormalSomeFace,'on')==1
                eIndex=size(exMetaMaterials(j).node,1);
                for enex2=1:length(nodex)
                    exMetaMaterials(j).node(end+1,:)=unitCell.interPolyhedron(j).node(nodex(enex2),:)+exl{j,k}(enex2,:);   % extrude node
                    exMetaMaterials(j).ExVec{k}(enex2,:)=exl{j,k}(enex2,:);
                end
                exMetaMaterials(j).BasicNodeIndex{k}=nodex;
                exMetaMaterials(j).ExNodeIndex{k}=[size(exMetaMaterials(j).node,1)-length(nodex)+1 :1: size(exMetaMaterials(j).node,1)];
                nEndface=size(exMetaMaterials(j).face,1);   nHinge=size(exMetaMaterials(j).hingeEx,1);
                for ex=1:length(nodex) % extrude faces from every internal polyhedron's face
                   exMetaMaterials(j).exfaceInfo{nEndface+ex,1}=k;
                    if ex~=length(nodex)
                        exMetaMaterials(j).face{nEndface+ex,1}=[nodex(ex)  nodex(ex+1)  eIndex+ex+1  eIndex+ex];
                        if ex==1
                            exMetaMaterials(j).hingeEx(nHinge+ex,:)=[eIndex+ex  nodex(ex) nodex(ex+1)  nodex(end) ];  % generate hinge Ex
                        else
                            exMetaMaterials(j).hingeEx(nHinge+ex,:)=[eIndex+ex  nodex(ex) nodex(ex+1)  nodex(ex-1) ];
                        end
                    elseif ex==length(nodex)   %  if it comes to last node
                        exMetaMaterials(j).face{nEndface+ex,1}=[nodex(ex)  nodex(1)  eIndex+1  eIndex+ex];
                        exMetaMaterials(j).hingeEx(nHinge+ex,:)=[eIndex+ex  nodex(ex) nodex(1)  nodex(ex-1) ];
                    end
                end
            end
        end
    end
    % ----------------------------- Finish extrusion ---------------------------
    exMetaMaterials(j).face(1)=[];    exMetaMaterials(j).hingeEx(1,:)=[];   exMetaMaterials(j).exfaceInfo(1,:)=[];
    %  Find other hingeEx based on the internal polyhedron nodes;
    for jex=1:size(unitCell.locPolyhedron(j).edge,1)
        kex=1;
        hingeNode=[];
        for iex=1:size(exMetaMaterials(j).face,1)
            if ismember(unitCell.locPolyhedron(j).edge(jex,1),exMetaMaterials(j).face{iex})==1 ...
                    && ismember(unitCell.locPolyhedron(j).edge(jex,2),exMetaMaterials(j).face{iex})==1
                candiFace=exMetaMaterials(j).face{iex};
                candiFace(candiFace==unitCell.locPolyhedron(j).edge(jex,1))=[];
                candiFace(candiFace==unitCell.locPolyhedron(j).edge(jex,2))=[];
                hingeNode(kex)=candiFace(1);
                kex=kex+1;
            end
        end
        if isempty(hingeNode)~=1 && length(hingeNode)>1
            exMetaMaterials(j).hingeEx(end+1,:)=[unitCell.locPolyhedron(j).edge(jex,1) unitCell.locPolyhedron(j).edge(jex, 2) hingeNode(1) hingeNode(2)];
        end
    end
end
end

function [unitCell]=findEdge(unitCell)
for i=1:length(unitCell)
    unitCell(i).edge=[];
    for j=1:size(unitCell(i).face,1)
        nedge=size(unitCell(i).edge,1);
        face=unitCell(i).face{j};
        switch length(unitCell(i).face{j})
            case 4
                % Including diagonal ones
                unitCell(i).edge(nedge+1:nedge+5,:)=[face(1) face(2); face(2)  face(3); face(3)  face(4); face(1)  face(3); face(2)   face(4);];
        end
    end
    unitCell(i).edge=unique(sort(unitCell(i).edge,2),'rows');
end
end

function [unitCell]=LocIndexUpdatedCoo(unitCell)
npoly=length(unitCell.Polyhedron);
for i=1:length(unitCell.GloPolyhedron)
    for j=1:size(unitCell.GloPolyhedron(i).face,1)
        gloFaceindex=unitCell.GloPolyhedron(i).face{j};
        if mod(i,npoly)==0
            iloc=npoly;
        else
            iloc=mod(i,npoly);
        end
        locFaceindex=unitCell.Polyhedron(iloc).face{j};
%         size( unitCell.GloPolyhedron(i).node,1)
%         gloFaceindex
        unitCell.locPolyhedron(i).node(locFaceindex,:)= unitCell.GloPolyhedron(i).node(gloFaceindex,:);
    end
    unitCell.locPolyhedron(i).face=unitCell.Polyhedron(iloc).face;
    unitCell.locPolyhedron(i).edge=unitCell.Polyhedron(iloc).edge;
end
end

function [unitCell]=FindGlobalIndex(unitCell)
unitCell.GeTemGlobal.node=[];  unitCell.GeTemGlobal.face=[];     unitCell.GeTemGlobal.edge=[];    unitCell.GeTemGlobal.hingeEx=[];

for i=1:length(unitCell.Polyhedron)
    nNode=size(unitCell.GeTemGlobal.node,1);  nFace=size(unitCell.GeTemGlobal.face,1);
    nEdge=size(unitCell.GeTemGlobal.edge,1);
    nHingeEx=size(unitCell.GeTemGlobal.hingeEx,1);
    %  Construct the global node's information of Generalized template
    unitCell.GeTemGlobal.node(nNode+1:nNode+size(unitCell.Polyhedron(i).node,1),:)=unitCell.Polyhedron(i).node;
    for j=1:size(unitCell.Polyhedron(i).face,1)
        unitCell.GeTemGlobal.face{nFace+j,1}=unitCell.Polyhedron(i).face{j}+nNode;
        unitCell.GeTemGlobal.faceIdx(nFace+j,:)=[j i]; % j-th face of i-th polyhedron\
        if isfield(unitCell.Polyhedron,'exfaceInfo')==1
        unitCell.GeTemGlobal.exfaceIdx(nFace+j,:)=[unitCell.Polyhedron(i).exfaceInfo{j} i];
        end
    end
    unitCell.GeTemGlobal.edge(nEdge+1: nEdge+size(unitCell.Polyhedron(i).edge,1),: )=unitCell.Polyhedron(i).edge+nNode;
    if isfield(unitCell.Polyhedron,'hingeEx')==1
        unitCell.GeTemGlobal.hingeEx(nHingeEx+1:nHingeEx+size(unitCell.Polyhedron(i).hingeEx,1),: )=unitCell.Polyhedron(i).hingeEx+ nNode;
    end
end
end


function [unitCell]=reArrangePoly(unitCell, tessellateLayout)
npoly=length(unitCell.Polyhedron) ; %  the number of polyhedrons in one unit
nfaceUnit=sum([unitCell.Polyhedron(1:npoly).nFace]);   % the total number of faces in one unit cell of the template
nedgeUnit=sum([unitCell.Polyhedron(1:npoly).nEdge]);
for i=1: (size(tessellateLayout,1)+1)*npoly     % i is the i-th number of polyhedron
    j=mod(i,npoly) ; %  local, j-th polyhedron in unit template
    k=(i-j)/npoly;
    if j==1 && k==0
        unitCell.GloPolyhedron(i).face=unitCell.GeTemGlobal.face(...
            1+k*nfaceUnit: sum([unitCell.Polyhedron(1:j).nFace])+k*nfaceUnit,1);
        unitCell.GloPolyhedron(i).edge=unitCell.GeTemGlobal.edge(...
            [1:sum([unitCell.Polyhedron(1:j).nEdge])]+k*nedgeUnit,:);
    else
        if j==0
            j=npoly;       k=k-1;
        end
        unitCell.GloPolyhedron(i).face=unitCell.GeTemGlobal.face(...
            sum([unitCell.Polyhedron(1:j-1).nFace])+1+k*nfaceUnit:...
            sum([unitCell.Polyhedron(1:j).nFace])+k*nfaceUnit,1);
        unitCell.GloPolyhedron(i).edge=unitCell.GeTemGlobal.edge(...
            [sum([unitCell.Polyhedron(1:j-1).nEdge])+1:sum([unitCell.Polyhedron(1:j).nEdge])]+k*nedgeUnit,:);
    end
    unitCell.GloPolyhedron(i).node=unitCell.GeTemGlobal.node;
end
end

function [unitCell]=AlterPositionPolyhedra(unitCell)
for ne=1:(length(unitCell.Polyhedron)-1)
    centroidA=zeros(3,1); centroidB=zeros(3,1);
    for i=1:size(unitCell.expCon(ne).dir,1)
        pB(:,i)=unitCell.Polyhedron(unitCell.expCon(ne).dir(i,3)).node(unitCell.expCon(ne).dir(i,2),:)';
        pA(:,i)=unitCell.Polyhedron(ne+1).node(unitCell.expCon(ne).dir(i,1),:)';
        centroidB=centroidB+pB(:,i)/size(unitCell.expCon(ne).dir,1);
        centroidA=centroidA+pA(:,i)/size(unitCell.expCon(ne).dir,1);
    end
    H=zeros(3);
    for i=1:size(unitCell.expCon(ne).dir,1)
        H=H+(pA(:,i)-centroidA)*(pB(:,i)-centroidB)';
    end
    [U,S,V]=svd(H);
    R=V*U';   % Looks like polar decomposation
    if det(R)<0
        V(:,3)=V(:,3)*-1;
        R=V*U';
    end
    t=-R*centroidA+centroidB;
    centroidB=ones(size(unitCell.Polyhedron(ne+1).node,1),1)*centroidB';
    for i=1:size(unitCell.Polyhedron(ne+1).node,1)
        unitCell.Polyhedron(ne+1).node(i,:)=(R*unitCell.Polyhedron(ne+1).node(i,:)'+t)';
    end
end
end

function [mnode,medge,mface,mhinge]=mergeNodeAdvance(node,edge,face,hinge)
% This version will delete the overplapping nodes and update the
% information in the edge and face
nM=1; % the cell matrix index colloect the information of overlapping node
mNode=[];
% find unique nodes exsit in the faces

IdxNN = knnsearch(node,node,'K',2);
for i=1:size(IdxNN,1)
    caindx=IdxNN(i,IdxNN(i,:)~=i);
    nstNodeidx(i,:)=caindx(1);
    nstNode(i,:)=node( nstNodeidx(i,:),:);
    distance=norm(nstNode(i,:)-node(i,:));
    if distance<=10e-7
        mNode(nM,:)=[i nstNodeidx(i,:)];
        nM=nM+1;
    end
end
if isempty(mNode)==1
    mnode=node;  medge=edge;  mface=face;  mhinge=hinge;
else
    mNodeUp=unique(sort(mNode,2),'rows');  % Keep the key information of deleteing nodes, the second column is the nodes needed to be deleted
    % Keep only one nodes when one position has more than two nodes
    deRo=[];
    for i=1:size(mNodeUp,1)
        if ismember(mNodeUp(i,1),mNodeUp(:,2))==1
            if ismember(mNodeUp(i,2),mNodeUp(:,2))==1
                deRo=[deRo;i;];
            end
        end
    end
    mNodeUp(deRo,:)=[];
    slave=mNodeUp(:,2);
    % Replace the index of slave overlapped nodes
    edgeUp=edge;    faceUp=face;    hingeUp=hinge;
    % new knn search for reducing time
    faceUpMat=[];  faceUpidx=[];
    for i=1:size(faceUp,1)
        for  j=1:length(faceUp{i})
            faceUpidx(i,:)=[length(faceUpMat)+1, length(faceUpMat)+length(faceUp{i})];
            faceUpMat=[faceUpMat, faceUp{i}];
        end
    end
    % ------------------- Previous brute loop ------------------
    for i=1:size(slave,1)
        edgeUp(edge==slave(i))=mNodeUp(i,1);  % update the element in the edges
        faceUpMat(faceUpMat==slave(i))=mNodeUp(i,1);
        if isempty(hingeUp)~=1
            hingeUp(hinge==slave(i))=mNodeUp(i,1);
        end
    end
    % --------------------------------------------------------------
    % Delete overlapping node
    nindex = linspace(1,size(node,1),size(node,1));
    nindex(mNodeUp(:,2))=[];
    node(mNodeUp(:,2),:)=[];
    % Update the new index to the edge and face
    edgeUp2=edgeUp;
    faceUp2Mat=faceUpMat;
    hingeUp2= hingeUp;
    for i=1:size(nindex,2)
        edgeUp2(edgeUp==nindex(i))=i;  % update the element in the edges
        faceUp2Mat(faceUp2Mat==nindex(i))=i;
        if isempty(hingeUp)~=1
            hingeUp2(hingeUp==nindex(i))=i;
        end
    end
    for i=1:size(faceUp,1)
        faceUp2{i,1}=faceUp2Mat(faceUpidx(i,1):faceUpidx(i,2));
    end
    mnode=node;  medge=edgeUp2;  mface=faceUp2;  mhinge= hingeUp2; % mface is not uniqued
end
%%%%% delete the nodes that does not exist in face and edge
uniNodeidx=unique(medge);
if length(uniNodeidx)<size(node,1)
    mNodePastCur0=[[1:1:length(uniNodeidx)]' , uniNodeidx];  mNodePastCur=[];
    % find the nodeidx needed to be replaced
    for nn=1:size(mNodePastCur0,1)
        if mNodePastCur0(nn,1)~=mNodePastCur0(nn,2)
            mNodePastCur=[mNodePastCur; mNodePastCur0(nn,:)];
        end
    end
    % --------------------------------- Brutal replace the node in face, edge, and hingeIdx  -------------------------
    if isempty(mNodePastCur)==0
        mnode=[];    mnode=node(uniNodeidx,:);
        for ff=1:size(mNodePastCur,1)
            %         find(medge==mNodePastCur(ff,2))
            medge(medge==mNodePastCur(ff,2))=mNodePastCur(ff,1);
            mhinge(mhinge==mNodePastCur(ff,2))=mNodePastCur(ff,1);
            for pc=1:size(mface,1)
                mface{pc}(mface{pc}==mNodePastCur(ff,2))=mNodePastCur(ff,1);
            end
        end
    end
end
end

%  This function gives the Jacobian matrix of tempalte
function [mobility,jj]=CalMobility(Node,Face1,Edge1)
node=Node;
face=Face1;
edge=Edge1;
numEdge=size(edge,1); 
ja=zeros(10*size(face,1), 3*size(node,1));
jw=zeros(numEdge, 3*size(node,1));
for j=1:numEdge
    k(j,:)=node(edge(j,1),:)-node(edge(j,2),:);
    jw(j,(edge(j,1)-1)*3+1: (edge(j,1)-1)*3+3)=k(j,:);
    jw(j,(edge(j,2)-1)*3+1: (edge(j,2)-1)*3+3)=-k(j,:);
end
x=1;
for j=1:size(face,1)     %
    if (size(face{j},2)>3)%
        for r=4:size(face{j},2) %
            pf1=node(face{j}(1),:);
            pf2=node(face{j}(2),:);
            pf3=node(face{j}(3),:);
            pf4=node(face{j}(r),:);
            kf1=cross((pf3-pf2),(pf3-pf4));
            kf2=cross((pf3-pf1),(pf4-pf1));
            kf3=cross((pf4-pf1),(pf2-pf1));
            kf4=cross((pf2-pf1),(pf3-pf1));
            ja(x,(face{j}(1)-1)*3+1:  (face{j}(1)-1)*3+3)=kf1;
            ja(x,(face{j}(2)-1)*3+1:  (face{j}(2)-1)*3+3)=kf2;
            ja(x,(face{j}(3)-1)*3+1:  (face{j}(3)-1)*3+3)=kf3;
            ja(x,(face{j}(r)-1)*3+1:  (face{j}(r)-1)*3+3)=kf4;
            x=x+1;
        end
    end
end
% Augment ja matrix if we don't have much FACE CONSTRAINTS
if size(ja,2)<size(jw,2)
    ja(:,end+1:end+(size(jw,2)-size(ja,2)))=zeros(size(ja,1),(size(jw,2)-size(ja,2)));
end
%Constrains globe matrice
jj=[jw;ja];
mobility=size(jj,2)-rank(jj)-6;
end

function  Plot(Polyhedron,viewPoint,Text,fText,object,pic,numUnitPoly,trans)
% Loop from i-th polyhedron
for i=1:length(Polyhedron)
    % Select color for every polyhedron
    if strcmp(object,'polyhedra')==1
        switch mod(i,numUnitPoly)
            case 0
                %                 facecolor=[250 240 230]./256;
                facecolor=[255 240 245]./256;   % original
            case 1
                %                   facecolor=[250 240 230]./256;
                facecolor=[255 193 193]./256;    % original
            case 2
                facecolor=[250 240 230]./256;
            case 3
                facecolor=[240 248 255]./256;
            case 4
                facecolor=[238 224 229]./256;
            case 5
                facecolor=[238 200 229]./256;
            case 6
                facecolor=[245 200 210]./256;
            case 7
                facecolor=[245 220 210]./256;
            case 8
                facecolor=[255 193 193]./256;
            case 9
                facecolor=[250 240 230]./256;
            case 10
                facecolor=[240 248 255]./256;
            case 11
                facecolor=[238 200 229]./256;
            case 12
                facecolor=[238 224 229]./256;
            case 13
                facecolor=[245 220 210]./256;
            case 14
                facecolor=[245 200 210]./256;
        end
    end
    if strcmp(object,'interPolyhedra')==1
        facecolor=[199,21,133]/256;
    elseif strcmp(object,'Snapology')==1
        excolor= [147,112,219]/256 ;   % Original
        incolor= [255 193 193]./256;    % Original
        %         incolor=excolor;
        Lightpoint=2*[cosd(viewPoint(2))*sind(viewPoint(1)), -cosd(viewPoint(2))*cosd(viewPoint(1)), sind(viewPoint(2))];
    elseif  strcmp(object,'transSnapology')==1
        facecolor=[255 240 245]./256;
    end
    if strcmp(Text,'text')==1
        for kk=1:size(Polyhedron(i).node,1)  % text the nodes
            text(Polyhedron(i).node(kk,1),Polyhedron(i).node(kk,2),Polyhedron(i).node(kk,3),num2str(kk),'fontsize',12,'color','k');
        end
        bodyCenter=sum(Polyhedron(i).node)/size(Polyhedron(i).node,1);
        text(bodyCenter(1),bodyCenter(2),bodyCenter(3),num2str(i),'fontsize',16,'color','r');
    end
    for j=1:length(Polyhedron(i).face)
        if isempty(Polyhedron(i).face{j})==0
            if strcmp(fText,'ftext')==1
                indexX=sum(Polyhedron(i).node(:,1))/size(Polyhedron(i).node,1);
                indexY=sum(Polyhedron(i).node(:,2))/size(Polyhedron(i).node,1);
                indexZ=sum(Polyhedron(i).node(:,3))/size(Polyhedron(i).node,1);
                text(indexX, indexY, indexZ,num2str(i),'fontsize',14,'Color','b');  % indicate j-th polyhedron this is
                faceCenter=sum(Polyhedron(i).node([Polyhedron(i).face{j}(1:end)],:))/length(Polyhedron(i).face{j});
                text( faceCenter(1), faceCenter(2), faceCenter(3),num2str(j),'fontsize',12,'Color','m');
            end
            if strcmp(object,'polyhedra')==1 || strcmp(object,'interPolyhedra') || strcmp(object,'transSnapology')==1
                if pic==3 || pic==5
                    transp=0.15;  edgecolor=[192,192,192]/256;  lineWidth=0.01;   %  transp=0.14;
                else
                    transp=0.45;  edgecolor='k';  lineWidth=0.1;
                end
                patch('Faces',Polyhedron(i).face{j},'Vertices',Polyhedron(i).node,'FaceColor',facecolor,'facealpha',transp,'EdgeColor',edgecolor,'LineWidth',lineWidth); % EdgeColor [192,192,192]/256
                hold on ;
            elseif strcmp(object,'Snapology')==1
                nodes=Polyhedron(i).node;  faces=Polyhedron(i).face{j};
                faNormal(j,:)=cross((nodes(faces(3),:)-nodes(faces(2),:)),(nodes(faces(1),:)-nodes(faces(2),:)))...
                    /norm(cross((nodes(faces(3),:)-nodes(faces(2),:)),(nodes(faces(1),:)-nodes(faces(2),:))));
                if dot(faNormal(j,:),Lightpoint)>0
                    patch('Faces',Polyhedron(i).face{j},'Vertices',Polyhedron(i).node,'FaceColor',excolor,'facealpha',trans,'LineWidth',0.01,'EdgeColor','k'); %
                elseif dot(faNormal(j,:),Lightpoint)<0
                    patch('Faces',Polyhedron(i).face{j},'Vertices',Polyhedron(i).node,'FaceColor',incolor,'facealpha',trans,'LineWidth',0.01,'EdgeColor','k'); %
                end
            end
        end
    end
end
% End loop
view(viewPoint(1),viewPoint(2))
axis equal
axis off
grid off

if strcmp(object,'Snapology')==1
    light('color','w','style','infinite','position',Lightpoint)
    lighting flat
end
material dull
set(gcf,'color','w')

end

function [cycles,cnect]=PlotLoops(locPoly,cnect,deSFpIdx,rempoly,innerfacepair, viewpoint,plotOrNot)
uniNode=[];
% find the valid connections between units
if isempty(deSFpIdx)==0
    disCnctIdx=[];
    for r=1:length(rempoly)
        [r1,c1]=find(innerfacepair(:,3:4)==rempoly(r));
        disCnctIdx=[disCnctIdx, r1'];
    end
    for i=1:size(deSFpIdx,1)
        [rr,cc]=find(innerfacepair(:,3:4)==deSFpIdx(i,2));
        for j=1:length(rr)
            if innerfacepair(rr(j),cc(j))==deSFpIdx(i,1)
                disCnctIdx=[disCnctIdx, rr(j)];
            end
        end
    end
    remainFacePair=innerfacepair(:,3:4);
    remainFacePair(disCnctIdx,:)=[];
    cnect=unique(sort(remainFacePair,2),'rows');
end

g=GenerateAdjacencyMatrix(cnect,max(max(cnect)));
G = graph(g);
% figure
% plot(G,'b','LineWidth',1,'MarkerSize',7,'NodeFontSize',12)
[cycles,edgecycles] = cyclebasis(G);

if strcmp(plotOrNot,'yes')==1
    for i=1:size(cnect,1)
        fnidx=cnect(i,1);  pnidx=cnect(i,2);
        fn=sum(locPoly(fnidx).node)/size(locPoly(fnidx).node,1);
        pn=sum(locPoly(pnidx).node)/size(locPoly(pnidx).node,1);
        line([fn(1) pn(1)],[fn(2) pn(2)],[fn(3) pn(3)],'Color','b','Marker','.','MarkerSize',30,'LineWidth',3)%
%         text( fn(1), fn(2), fn(3),num2str(fnidx),'Color','r','FontSize',14)
        hold on
        uniNode=[uniNode fnidx];
    end
    axis equal
    grid on
    view(viewpoint(1),viewpoint(2))
    uniNode=unique(uniNode);
end
end
function [mface,mhingeEx]=mergeCommonEdgeOnFace(Bar)
  faceInfo=cell2mat(Bar.face);
  mhingeEx=Bar.hingeEx;
  for f=1:size(Bar.face,1)
      faceEdge(2*f-1,:)=[Bar.face{f}(2) Bar.face{f}(3);];
      faceEdge(2*f,:)=[Bar.face{f}(4) Bar.face{f}(1);];
  end
   faceEdge=unique(sort(faceEdge,2),'rows');
  cmEdge=sort(faceInfo(:,3:4),2);
  [Cc,icm,iac]=unique(cmEdge,'rows');
re=1;
mm=1;
  for i=1:size(Cc,1)
      cmfaceidx=(find(iac==i));
      if length(cmfaceidx)>1
      face1=Bar.face{cmfaceidx(1)};   face2=Bar.face{cmfaceidx(2)};  % adjacent face 
      den1=[]; den2=[];
      for j=1:length(Cc(i,:))
      % ---- merge faceEdge first
      [iFEr, iFEc]=find(faceEdge==Cc(i,j));
      if length(iFEr)>1
%       faceEdge(iFEr,:)
      repEdge(re,:)=[Cc(i,j), setxor(faceEdge(iFEr(1),:),faceEdge(iFEr(2),:))]; % common edge vertex 1,  v2 , v3 are co-linear 
       % ---- merge hinge 
       meidx=[1 3 4];
       for mi=1:length(meidx)
      mhir=find(mhingeEx(:,meidx(mi))==repEdge(re,1));
      if isempty(mhir)==0
          for mh=1:length(mhir)
           [lia,lib]= ismember(repEdge(re,:),   mhingeEx(mhir(mh),:));
            mhingeEx(mhir(mh),meidx(mi))=repEdge(re,lia==0);
          end
      end
       end
       re=re+1;
      % merge face
     den1=[den1   find(face1==Cc(i,j))];   
     den2=[den2   find(face2==Cc(i,j))];
      end
      end
      %       if isempty(den1)==0  ||   isempty(den2)==0
      if cmfaceidx(2)~= cmfaceidx(1)
          face1(den1)=[];    face2(den2)=[];
          mface{mm,1}=[face1  face2];
          mm=mm+1;
      elseif  cmfaceidx(2)== cmfaceidx(1)
          mface{mm,1}=face1;
          mm=mm+1;
      end
      elseif length(cmfaceidx)==1
         mface{mm,1}= Bar.face{cmfaceidx};
          mm=mm+1;
      end
  end
end

function g=GenerateAdjacencyMatrix(cnect,numNodes)
g=zeros(numNodes,numNodes);
for i=1:size(cnect,1)
    g(cnect(i,1),cnect(i,2))=1;
    g(cnect(i,2),cnect(i,1))=1;
end
end