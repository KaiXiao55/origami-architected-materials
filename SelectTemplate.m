function [unitCell]=SelectTemplate(opt)
switch opt.template
    case {'#1'}
        unitCell.Polyhedron(1)=polyhedra('tetrahedron');   unitCell.PolyName{1}='tetrahedron';
        unitCell.Polyhedron(2)=polyhedra('octahedron');    unitCell.PolyName{2}='octahedron';
        unitCell.Polyhedron(3)=polyhedra('tetrahedron');   unitCell.PolyName{3}='tetrahedron';
        unitCell.expCon(1).dir=[2 4 1; 1 2 1; 4 1 1];
        unitCell.expCon(2).dir=[3 6 2; 4 3 2; 2 5 2];
        unitCell.perCon=[1 1 1 2; 2 8 1 2; 4 5 1 2];
        unitCell.ViewPoint=[-91 7];    % sphereical template
        %             unitCell.ViewPoint=[-79 16];   % cylinder template
    case {'#2'}
        unitCell.Polyhedron(1)=polyhedra('tetrahedron');    unitCell.PolyName{1}='tetrahedron';
        unitCell.Polyhedron(2)=polyhedra('octahedron');    unitCell.PolyName{2}='octahedron';
        unitCell.Polyhedron(3)=polyhedra('tetrahedron');    unitCell.PolyName{3}='tetrahedron';
        unitCell.Polyhedron(4)=polyhedra('octahedron');     unitCell.PolyName{4}='octahedron';
        unitCell.Polyhedron(5)=polyhedra('tetrahedron');   unitCell.PolyName{5}='tetrahedron';
        unitCell.Polyhedron(6)=polyhedra('tetrahedron');   unitCell.PolyName{6}='tetrahedron';
        unitCell.expCon(1).dir=[2 4 1; 1 2 1; 4 1 1];
        unitCell.expCon(2).dir=[3 6 2; 4 3 2; 2 5 2];
        unitCell.expCon(3).dir=[4 4 2; 1 5 2; 2 6 2];
        unitCell.expCon(4).dir=[2 2 3; 4 1 3; 3 3 3];
        unitCell.expCon(5).dir=[2 5 4; 4 6 4; 3 4 4];
        unitCell.perCon=[1 3 1 6; 2 8 1 2; 4 5 1 2];
        unitCell.ViewPoint=[-44 30];
    case {'#3'}
        unitCell.Polyhedron(1)=polyhedra('tetrahedron');    unitCell.PolyName{1}='tetrahedron';
        unitCell.Polyhedron(2)=polyhedra('octahedron');     unitCell.PolyName{2}='octahedron';
        unitCell.Polyhedron(3)=polyhedra('tetrahedron');     unitCell.PolyName{3}= 'tetrahedron';
        unitCell.Polyhedron(4)=polyhedra('triangular prism');    unitCell.PolyName{4}='triangular prism';
        unitCell.Polyhedron(5)=polyhedra('triangular prism');     unitCell.PolyName{5}='triangular prism';
        unitCell.expCon(1).dir=[2 4 1; 1 2 1; 4 1 1];
        unitCell.expCon(2).dir=[3 6 2; 4 3 2; 2 5 2];
        unitCell.expCon(3).dir=[5 4 2; 4 5 2; 6 6 2];
        unitCell.expCon(4).dir=[1 2 3; 3 3 3; 2 1 3];
        unitCell.perCon=[1 4 1 4; 2 8 1 2; 4 5 1 2];
        unitCell.ViewPoint=[-44 30];
    case {'#3c'}
        unitCell.Polyhedron(1)=polyhedra('tetrahedron');    unitCell.PolyName{1}='tetrahedron';
        unitCell.Polyhedron(2)=polyhedra('octahedron');     unitCell.PolyName{2}='octahedron';
        unitCell.Polyhedron(3)=polyhedra('tetrahedron');    unitCell.PolyName{3}='tetrahedron';
        unitCell.Polyhedron(4)=polyhedra('octahedron');     unitCell.PolyName{4}='octahedron';
        unitCell.Polyhedron(5)=polyhedra('tetrahedron');     unitCell.PolyName{5}='tetrahedron';
        unitCell.Polyhedron(6)=polyhedra('octahedron');     unitCell.PolyName{6}='octahedron';
        unitCell.Polyhedron(7)=polyhedra('tetrahedron');     unitCell.PolyName{7}='tetrahedron';
        unitCell.Polyhedron(8)=polyhedra('triangular prism');    unitCell.PolyName{8}='triangular prism';
        unitCell.Polyhedron(9)=polyhedra('triangular prism');    unitCell.PolyName{9}='triangular prism';
        unitCell.Polyhedron(10)=polyhedra('triangular prism');    unitCell.PolyName{10}='triangular prism';
        unitCell.Polyhedron(11)=polyhedra('triangular prism');    unitCell.PolyName{11}='triangular prism';
        unitCell.Polyhedron(12)=polyhedra('triangular prism');    unitCell.PolyName{12}='triangular prism';
        unitCell.Polyhedron(13)=polyhedra('triangular prism');    unitCell.PolyName{13}='triangular prism';
        unitCell.Polyhedron(14)=polyhedra('triangular prism');    unitCell.PolyName{14}='triangular prism';
        unitCell.Polyhedron(15)=polyhedra('triangular prism');    unitCell.PolyName{15}='triangular prism';
        unitCell.Polyhedron(16)=polyhedra('triangular prism');    unitCell.PolyName{16}='triangular prism';
         unitCell.Polyhedron(17)=polyhedra('triangular prism');    unitCell.PolyName{17}='triangular prism';
        unitCell.expCon(1).dir=[2 4 1; 1 2 1; 4 1 1];  % v2 v1 p1
        unitCell.expCon(2).dir=[1 6 2; 2 4 2; 4 2 2];
        unitCell.expCon(3).dir=[5 2 3; 6 3 3; 3 4 3];
        unitCell.expCon(4).dir=[1 5 4; 3 4 4; 4 1 4];
        unitCell.expCon(5).dir=[4 2 5; 6 1 5; 2 4 5];
        unitCell.expCon(6).dir=[2 5 6; 3 6 6; 4 3 6];
        unitCell.expCon(7).dir=[1 2 7; 2 1 7; 3 3 7];
        unitCell.expCon(8).dir=[5 4 2; 4 5 2; 6 6 2];
        unitCell.expCon(9).dir=[4 2 9; 5 3 9; 2 6 9];
        unitCell.expCon(10).dir=[1 4 10; 3 6 10; 4 1 10];
        unitCell.expCon(11).dir=[5 1 11; 6 2 11; 2 4 11];
         unitCell.expCon(12).dir=[2 4 12; 3 5 12; 6 2 12];
         unitCell.expCon(13).dir=[2 3 1; 1 2 1; 3 4 1]; 
       unitCell.expCon(14).dir=[6 2 2; 4 1 2; 5 3 2];   
       unitCell.expCon(15).dir=[6 2 4; 4 1 4; 5 3 4];   
       unitCell.expCon(16).dir=[6 2 6; 4 1 6; 5 3 6];   
        unitCell.perCon=[3 3 9 12; 2 1 10 13; 4 4 9 15];
        unitCell.ViewPoint=[-44 30];
    case {'#4'}
        unitCell.Polyhedron(1)=polyhedra('tetrahedron');   unitCell.PolyName{1}='tetrahedron';
        unitCell.Polyhedron(2)=polyhedra('octahedron');    unitCell.PolyName{2}='octahedron';
        unitCell.Polyhedron(3)=polyhedra('tetrahedron');   unitCell.PolyName{3}='tetrahedron';
        unitCell.Polyhedron(4)=polyhedra('triangular prism');   unitCell.PolyName{4}='triangular prism';
        unitCell.Polyhedron(5)=polyhedra('triangular prism');   unitCell.PolyName{5}='triangular prism';
        unitCell.Polyhedron(6)=polyhedra('octahedron');   unitCell.PolyName{6}='octahedron';
        unitCell.Polyhedron(7)=polyhedra('tetrahedron');  unitCell.PolyName{7}='tetrahedron';
        unitCell.Polyhedron(8)=polyhedra('tetrahedron');   unitCell.PolyName{8}='tetrahedron';
        unitCell.Polyhedron(9)=polyhedra('triangular prism');    unitCell.PolyName{9}='triangular prism';
        unitCell.Polyhedron(10)=polyhedra('triangular prism');   unitCell.PolyName{10}='triangular prism';
        unitCell.expCon(1).dir=[2 4 1; 1 2 1; 4 1 1];
        unitCell.expCon(2).dir=[3 6 2; 4 3 2; 2 5 2];
        unitCell.expCon(3).dir=[5 4 2; 4 5 2; 6 6 2];
        unitCell.expCon(4).dir=[1 2 3; 3 3 3; 2 1 3];
        unitCell.expCon(5).dir=[5 1 4; 3 3 4; 1 2 4];
        unitCell.expCon(6).dir=[1 2 6; 4 4 6; 3 1 6];
        unitCell.expCon(7).dir=[2 4 5; 4 6 5; 1 5 5];
        unitCell.expCon(8).dir=[5 2 7; 4 4 7; 6 1 7];
        unitCell.expCon(9).dir=[1 4 6; 3 2 6; 2 6 6];
        unitCell.perCon=[1 4 1 9; 2 8 1 2; 4 5 1 2];
%         unitCell.ViewPoint=[-44 30];
        unitCell.ViewPoint=[-44 18];
    case {'#5'}
        unitCell.Polyhedron(1)=polyhedra('rhombicuboctahedron');   unitCell.PolyName{1}='rhombicuboctahedron';
        unitCell.Polyhedron(2)=polyhedra('cube');                   unitCell.PolyName{2}='cube';
        unitCell.Polyhedron(3)=polyhedra('tetrahedron');    unitCell.PolyName{3}='tetrahedron';
        unitCell.Polyhedron(4)=polyhedra('tetrahedron');    unitCell.PolyName{4}='tetrahedron';
        unitCell.expCon(1).dir=[3 5 1; 7 6 1; 8 14 1];
        unitCell.expCon(2).dir=[3 10 1; 2 14 1;4 22 1];
        unitCell.expCon(3).dir=[3 16 1; 2 24 1; 1 12 1];
        unitCell.perCon=[18 13 1 1; 10 7 1 1; 16 11 1 1];
        unitCell.ViewPoint=[-103 23];
    case {'#6'}
        unitCell.Polyhedron(1)=polyhedra('tetrahedron');
        unitCell.Polyhedron(2)=polyhedra('truncated tetrahedron');
        unitCell.Polyhedron(3)=polyhedra('truncated tetrahedron');
        unitCell.Polyhedron(4)=polyhedra('tetrahedron');
        unitCell.PolyName{1}='tetrahedron';    unitCell.PolyName{2}='truncated tetrahedron';
        unitCell.PolyName{3}= 'truncated tetrahedron';   unitCell.PolyName{4}='tetrahedron';
        unitCell.expCon(1).dir=[4 1 1; 10 2 1; 2 4 1];
        unitCell.expCon(2).dir=[4 7 2; 10 8 2; 5 3 2];
        unitCell.expCon(3).dir=[3 8 3; 4 12 3; 2 11 3];
        unitCell.perCon=[1 4 1 2; 2 1 1 2; 4 2 1 2];
        unitCell.ViewPoint=[-57 31];
    case {'#7','Fig1b'}
        unitCell.Polyhedron(1)=polyhedra('cuboctahedron');
        unitCell.Polyhedron(2)=polyhedra('octahedron');
        unitCell.PolyName{1}='cuboctahedron';    unitCell.PolyName{2}='octahedron';
        unitCell.expCon(1).dir=[1 3 1; 2 9 1; 3 6 1];
        unitCell.perCon=[4 6 1 1; 5 3 1 1; 1 2 1 1];
        unitCell.ViewPoint=[-128 22];
    case {'#8'}
        unitCell.Polyhedron(1)=polyhedra('truncated cube');
        unitCell.Polyhedron(2)=polyhedra('octahedron');
        unitCell.expCon(1).dir=[1 7 1; 2 9 1; 3 16 1];
        unitCell.perCon=[4 3 1 1; 6 5 1 1; 1 2 1 1];
        unitCell.ViewPoint=[-44 30];
    case {'#9','Fig6#b'}
        unitCell.Polyhedron(1)=polyhedra('rhombicuboctahedron');       unitCell.PolyName{1}='rhombicuboctahedron';
        unitCell.Polyhedron(2)=polyhedra('cuboctahedron');       unitCell.PolyName{2}='cuboctahedron';
        unitCell.Polyhedron(3)=polyhedra('cube');        unitCell.PolyName{3}='cube';
        unitCell.Polyhedron(4)=polyhedra('cube');       unitCell.PolyName{4}='cube';
        unitCell.Polyhedron(5)=polyhedra('cube');       unitCell.PolyName{5}='cube';
        unitCell.expCon(1).dir=[2 14 1; 4 22 1; 1 10 1];
        unitCell.expCon(2).dir=[7 12 1; 3 24 1; 1 22 1];
        unitCell.expCon(3).dir=[7 22 1; 5 14 1; 3 21 1];
        unitCell.expCon(4).dir=[7 2 1; 3 6 1; 4 14 1];
        unitCell.perCon=[4 3 1 1;6 5 1 1 ;1 2 1 1];
        if strcmp(opt.template,'Fig6#b')
            unitCell.Polyhedron(1).solidify=[1,2,3,4,5,6,8,9,11,13,16,18,19,20,21,22,24,26];
            unitCell.Polyhedron(2).solidify=[7,9,11,12,13,14];
            unitCell.Polyhedron(3).solidify=[3,4];
            unitCell.Polyhedron(4).solidify=[2,5];
            unitCell.Polyhedron(5).solidify=[2,5];
        end
        %         unitCell.ViewPoint=[-44 30]; % orginal
        unitCell.ViewPoint=[-196 13];
    case {'#10'}
        unitCell.Polyhedron(1)=polyhedra('truncated octahedron');
        unitCell.Polyhedron(2)=polyhedra('cuboctahedron');
        unitCell.Polyhedron(3)=polyhedra('truncated tetrahedron');
        unitCell.Polyhedron(4)=polyhedra('truncated tetrahedron');
        unitCell.expCon(1).dir=[1 13 1; 4 19 1; 7 23 1];
        unitCell.expCon(2).dir=[6 17 1; 5 15 1; 9 23 1];
        unitCell.expCon(3).dir=[9 19 1; 10 14 1; 3 23 1];
        unitCell.perCon=[9 5 1 3;10 8 1 4; 13 8 1 3];
        unitCell.ViewPoint=[-35 13];
        %         unitCell.ViewPoint=[136 15];
    case {'#11'}
        unitCell.Polyhedron(1)=polyhedra('triangular prism');
        unitCell.Polyhedron(2)=polyhedra('triangular prism');
        unitCell.expCon(1).dir=[6 4 1;5 5 1; 3 1 1];
        unitCell.perCon=[3 1 1 2;2 3 1 2;4 5 1 1];
        unitCell.ViewPoint=[-37 14];%[-131 35];
        unitCell.PolyName{1}='triangular prism';
        unitCell.PolyName{2}='triangular prism';
    case {'#12','Fig1c','Fig2g'}
        unitCell.Polyhedron(1)=polyhedra('triangular prism');
        unitCell.Polyhedron(2)=polyhedra('triangular prism');
        unitCell.Polyhedron(3)=polyhedra('triangular prism');
        unitCell.Polyhedron(4)=polyhedra('triangular prism');
        unitCell.expCon(1).dir=[6 5 1; 3 4 1; 2 1 1];
        unitCell.expCon(2).dir=[4 5 1; 6 6 1; 3 3 1];
        unitCell.expCon(3).dir=[4 5 3; 1 6 3; 2 3 3 ];
        unitCell.perCon=[3 1 1 3;2 3 4 2;4 5 1 1];
        unitCell.ViewPoint=[-123 35];
    case {'#13'}
        unitCell.Polyhedron(1)=polyhedra('cube');
        unitCell.Polyhedron(2)=polyhedra('triangular prism');
        unitCell.Polyhedron(3)=polyhedra('triangular prism');
        unitCell.expCon(1).dir=[6 8 1; 4 6 1; 1 2 1];
        unitCell.expCon(2).dir=[6 7 1; 5 5 1; 2 1 1];
        unitCell.perCon=[5 2 1 1;3 1 3 2;1 6 1 1];
        unitCell.ViewPoint=[138 17];
    case {'#14','Fig6#c'}
        unitCell.Polyhedron(1)=polyhedra('cube');    unitCell.PolyName{1}='cube';
        unitCell.Polyhedron(2)=polyhedra('triangular prism');    unitCell.PolyName{2}='triangular prism';
        unitCell.Polyhedron(3)=polyhedra('cube');       unitCell.PolyName{3}='cube';
        unitCell.Polyhedron(4)=polyhedra('triangular prism');     unitCell.PolyName{4}='triangular prism';
        unitCell.Polyhedron(5)=polyhedra('triangular prism');     unitCell.PolyName{5}='triangular prism';
        unitCell.Polyhedron(6)=polyhedra('triangular prism');     unitCell.PolyName{6}='triangular prism';
        unitCell.expCon(1).dir=[6 8 1; 4 6 1; 3 4 1];
        unitCell.expCon(2).dir=[5 4 2; 7 5 2; 3 2 2];
        unitCell.expCon(3).dir=[6 6 2; 4 5 2; 3 3 2];
        unitCell.expCon(4).dir=[6 5 1; 5 6 1; 3 1 1];
        unitCell.expCon(5).dir=[6 5 3; 5 6 3; 2 2 3];
        unitCell.perCon=[4 1 1 4;5 1 1 6;1 6 1 1];
        if strcmp(opt.template,'Fig6#c')
            unitCell.Polyhedron(1).solidify=[1 2 5 6];
            unitCell.Polyhedron(2).solidify=[2 ];
            unitCell.Polyhedron(4).solidify=[3 4 5];
            unitCell.Polyhedron(5).solidify=[2];
            unitCell.Polyhedron(6).solidify=[1];
        end
        unitCell.ViewPoint=[-42 33];
    case{'#14c'}
        unitCell.Polyhedron(1)=polyhedra('cube');    unitCell.PolyName{1}='cube';
        unitCell.Polyhedron(2)=polyhedra('triangular prism');    unitCell.PolyName{2}='triangular prism';
        unitCell.Polyhedron(3)=polyhedra('cube');       unitCell.PolyName{3}='cube';
        unitCell.Polyhedron(4)=polyhedra('triangular prism');     unitCell.PolyName{4}='triangular prism';
        unitCell.Polyhedron(5)=polyhedra('triangular prism');     unitCell.PolyName{5}='triangular prism';
        unitCell.Polyhedron(6)=polyhedra('triangular prism');     unitCell.PolyName{6}='triangular prism';
        unitCell.Polyhedron(7)=polyhedra('cube');     unitCell.PolyName{7}='cube';
        unitCell.Polyhedron(8)=polyhedra('triangular prism');     unitCell.PolyName{8}='triangular prism';
        unitCell.Polyhedron(9)=polyhedra('triangular prism');     unitCell.PolyName{9}='triangular prism';
        unitCell.Polyhedron(10)=polyhedra('cube');     unitCell.PolyName{10}='cube';
        unitCell.Polyhedron(11)=polyhedra('triangular prism');     unitCell.PolyName{11}='triangular prism';
        unitCell.Polyhedron(12)=polyhedra('cube');     unitCell.PolyName{10}='cube';
        unitCell.Polyhedron(13)=polyhedra('triangular prism');     unitCell.PolyName{13}='triangular prism';
        %          unitCell.Polyhedron(13)=polyhedra('triangular prism');     unitCell.PolyName{13}='triangular prism';
        unitCell.expCon(1).dir=[6 8 1; 4 6 1; 3 4 1];
        unitCell.expCon(2).dir=[5 4 2; 7 5 2; 3 2 2];
        unitCell.expCon(3).dir=[6 6 2; 4 5 2; 3 3 2];
        unitCell.expCon(4).dir=[6 5 1; 5 6 1; 3 1 1];
        unitCell.expCon(5).dir=[6 5 3; 5 6 3; 2 2 3];
        unitCell.expCon(6).dir=[7 4 4; 8 5 4; 4 2 4];
        unitCell.expCon(7).dir=[4 8 3; 1 4 3; 6 7 3];
        unitCell.expCon(8).dir=[6 5 8; 4 4 8; 1 1 8];
        unitCell.expCon(9).dir=[8 5 9; 4 2 9; 3 1 9];
        unitCell.expCon(10).dir=[6 6 3; 3 2 3; 2 4 3];
        unitCell.expCon(11).dir=[7 4 6; 3 1 6; 4 2 6];
        unitCell.expCon(12).dir=[4 6 12; 1 2 12; 3 4 12];
        unitCell.perCon=[4 2 1 7;5 2 1 12;1 6 1 1];
        %          unitCell.perCon=[];
        unitCell.ViewPoint=[-42 33];
    case {'#15'}
        unitCell.Polyhedron(1)=polyhedra('triangular prism');
        unitCell.Polyhedron(2)=polyhedra('cube');
        unitCell.Polyhedron(3)=polyhedra('triangular prism');
        unitCell.Polyhedron(4)=polyhedra('triangular prism');
        unitCell.Polyhedron(5)=polyhedra('cube');
        unitCell.Polyhedron(6)=polyhedra('triangular prism');
        unitCell.expCon(1).dir=[7 4 1; 8 5 1; 4 2 1];
        unitCell.expCon(2).dir=[6 6 2; 3 5 2; 2 1 2];
        unitCell.expCon(3).dir=[4 5 1; 6 6 1; 3 3 1];
        unitCell.expCon(4).dir=[5 6 4; 6 5 4; 1 3 4];
        unitCell.expCon(5).dir=[4 8 5; 1 7 5; 2 3 5];
        unitCell.perCon=[4 3 2 2;1 6 2 2;2 3 6 3];
        unitCell.ViewPoint=[-44 30];
    case {'#16','Fig6#d'}
        unitCell.Polyhedron(1)=polyhedra('hexagonal prism');
        unitCell.Polyhedron(2)=polyhedra('cube');
        unitCell.Polyhedron(3)=polyhedra('cube');
        unitCell.Polyhedron(4)=polyhedra('cube');
        unitCell.Polyhedron(5)=polyhedra('triangular prism');
        unitCell.Polyhedron(6)=polyhedra('triangular prism');
        unitCell.expCon(1).dir=[7 7 1; 8 8 1; 3 1 1];
        unitCell.expCon(2).dir=[7 9 1; 5 8 1; 3 3 1];
        unitCell.expCon(3).dir=[7 10 1; 5 9 1; 3 4 1];
        unitCell.expCon(4).dir=[4 5 4; 6 6 4; 3 2 4];
        unitCell.expCon(5).dir=[6 5 3; 5 6 3; 2 2 3];
        unitCell.perCon=[8 3 1 4;7 3 1 3;1 2 1 1];
        if strcmp(opt.template,'Fig6#d')
            unitCell.Polyhedron(1).solidify=[1 2 4 6 8];
            unitCell.Polyhedron(2).solidify=[2 3];
            unitCell.Polyhedron(3).solidify=[2 4];
            unitCell.Polyhedron(4).solidify=[3 5];
            unitCell.Polyhedron(6).solidify=[1 2 3 4 5];
        end
        unitCell.ViewPoint=[-44 30];
    case {'#17'}
        unitCell.Polyhedron(1)=polyhedra('hexagonal prism');
        unitCell.Polyhedron(2)=polyhedra('triangular prism');
        unitCell.Polyhedron(3)=polyhedra('triangular prism');
        unitCell.Polyhedron(4)=polyhedra('triangular prism');
        unitCell.Polyhedron(5)=polyhedra('triangular prism');
        unitCell.Polyhedron(6)=polyhedra('triangular prism');
        unitCell.Polyhedron(7)=polyhedra('triangular prism');
        unitCell.Polyhedron(8)=polyhedra('triangular prism');
        unitCell.Polyhedron(9)=polyhedra('triangular prism');
        unitCell.expCon(1).dir=[4 11 1; 5 10 1; 2 4 1];
        unitCell.expCon(2).dir=[4 10 1; 5 9 1; 2 3 1];
        unitCell.expCon(3).dir=[4 5 2; 6 6 2; 3 3 2];
        unitCell.expCon(4).dir=[4 4 3; 5 6 3; 2 3 3];
        unitCell.expCon(5).dir=[5 4 2; 6 6 2; 3 3 2];
        unitCell.expCon(6).dir=[5 12 1; 6 11 1; 2 6 1];
        unitCell.expCon(7).dir=[5 5 6; 6 4 6; 3 1 6];
        unitCell.expCon(8).dir=[6 9 1; 4 8 1; 1 2 1];
        unitCell.perCon=[8 2 1 5;3 3 1 6;1 2 1 1];
        unitCell.ViewPoint=[-44 30];
    case {'#18','Fig1a','Fig2f'}
        unitCell.Polyhedron(1)=polyhedra('hexagonal prism');   unitCell.PolyName{1}='hexagonal prism';
        unitCell.Polyhedron(2)=polyhedra('triangular prism');    unitCell.PolyName{2}='triangular prism';
        unitCell.Polyhedron(3)=polyhedra('triangular prism');    unitCell.PolyName{3}='triangular prism';
        unitCell.expCon(1).dir=[4 10 1; 6 11 1; 3 5 1];
        unitCell.expCon(2).dir=[6 7 1; 5 8 1; 2 2 1];
        unitCell.perCon=[1 8 2 1;2 4 2 1;1 2 1 1];
        unitCell.ViewPoint=[-108  44];%[-121 39];
        %  The meaning of facepair denotation:
        % [f1 f2 p1 p2]
        %         unitCell.facepair=[6 3 1 2;  3 2 1 3;    6 3 4 5;    3 2 4 6;       6 3 7 8;     3 2 7 9;      6 3 10 11;   3 2 10 12;...
        %             7 1 1 9; 5 3 1 6;    2 4 2 7;    1 8 2 4;       7 1 4 12;   5 3 7 12;   2 4 5 10 ;     1 8 8 10;...
        %             2 1 1 1;  2 1 4 4;   2 1 7 7;    2 1 10 10;   5 4 3 3;    5 4 2 2;      5 4 5 5;        5 4 6 6; ...
        %             5 4 8 8 ; 5 4 9 9;   5 4 11 11;  5 4 12 12; ];
        %         unitCell.PBCfacePair=[1  7  3  7;  4  2  1  8;   1  7   6  10;  4  2  4  11;...
        %                                                         3  5  3  4;  8  1  1  5;   3  5   9  10;  8  1  7  11;];
        %         unitCell.PBCpairLocIndex=size(unitCell.facepair,1);
        %         unitCell.facepair=[unitCell.facepair; unitCell.PBCfacePair;];
        %         [B,I]=sort(unitCell.facepair(:,1),1);
        %         unitCell.facepair=unitCell.facepair(I,:);
    case {'#19'}
        unitCell.Polyhedron(1)=polyhedra('decagonal prism');
        unitCell.Polyhedron(2)=polyhedra('triangular prism');
        unitCell.Polyhedron(3)=polyhedra('triangular prism');
        unitCell.expCon(1).dir=[1 23 1;2 24 1;4 11 1];
        unitCell.expCon(2).dir=[1 9 1; 4 21 1; 3 10 1];
        unitCell.perCon=[6 12 1 1 ; 10 4 1 1 ; 1 2 1 1;];
        unitCell.ViewPoint=[-20 22];
    case {'#20'}
        unitCell.Polyhedron(1)=polyhedra('rhombicuboctahedron');
        unitCell.Polyhedron(2)=polyhedra('octagonal prism');
        unitCell.Polyhedron(3)=polyhedra('octagonal prism');
        unitCell.Polyhedron(4)=polyhedra('octagonal prism');
        unitCell.Polyhedron(5)=polyhedra('cube');
        unitCell.Polyhedron(6)=polyhedra('cube');
        unitCell.Polyhedron(7)=polyhedra('cube');
        unitCell.Polyhedron(8)=polyhedra('truncated cube');
        unitCell.expCon(1).dir=[12 22 1; 6 14 1; 5 13 1];
        unitCell.expCon(2).dir=[6 12 1; 5 10 1; 11 22 1];
        unitCell.expCon(3).dir=[12 10 1; 4 14 1; 3 6 1];
        unitCell.expCon(4).dir=[3 4 1; 4 12 1; 1 2 1;];
        unitCell.expCon(5).dir=[3 5 1; 7 6 1; 8 14 1];
        unitCell.expCon(6).dir=[3 23 1; 1 21 1; 7 24 1];
        unitCell.expCon(7).dir=[22 9 3; 21 5 3; 13 15 3];
        unitCell.perCon=[17 8 1 3;9 4 1 2;8 8 1 2];
        unitCell.ViewPoint=[-19 10];
    case {'#21'}
        unitCell.Polyhedron(1)=polyhedra('truncated cuboctahedron');
        unitCell.Polyhedron(2)=polyhedra('truncated cube');
        unitCell.Polyhedron(3)=polyhedra('truncated tetrahedron');
        unitCell.Polyhedron(4)=polyhedra('truncated tetrahedron');
        unitCell.expCon(1).dir=[20 28 1; 18 26 1; 4 4 1 ];
        unitCell.expCon(2).dir=[10 48 1; 9 22 1; 5 12 1 ];
        unitCell.expCon(3).dir=[2 40 1; 12 30 1; 6 26 1];
        unitCell.perCon=[4 6 1 1 ; 3 5 1 1; 12 11 1 1];
        unitCell.ViewPoint=[-44 30];
    case {'#22'}
        unitCell.Polyhedron=polyhedra('cube');
        unitCell.PolyName{1}=('cube');
        unitCell.perCon=[6 1 1 1;4 3 1 1; 5 2 1 1];%%[6 1; 4 3; 5 2]
        unitCell.ViewPoint=[-66 22];
    case {'#23'}
        unitCell.Polyhedron(1)=polyhedra('decagonal prism');
        unitCell.Polyhedron(2)=polyhedra('cube');
        unitCell.Polyhedron(3)=polyhedra('cube');
        unitCell.Polyhedron(4)=polyhedra('cube');
        unitCell.Polyhedron(5)=polyhedra('hexagonal prism');
        unitCell.Polyhedron(6)=polyhedra('hexagonal prism');
        unitCell.expCon(1).dir=[7 24 1; 8 13 1; 4 1 1];
        unitCell.expCon(2).dir=[7 15 1; 5 14 1; 3 3 1];
        unitCell.expCon(3).dir=[7 17 1; 5 16 1; 3 5 1];
        unitCell.expCon(4).dir=[11 14 1; 12 13 1; 5 2 1];
        unitCell.expCon(5).dir=[11 16 1; 12 15 1; 6 3 1];
        unitCell.perCon=[3 12 4 1;3 10 3 1;1 2 1 1];
        unitCell.ViewPoint=[-44 30];
    case {'#24','Fig6#a'}
        unitCell.Polyhedron(1)=polyhedra('octagonal prism');
        unitCell.Polyhedron(2)=polyhedra('cube');
        unitCell.expCon(1).dir=[7 2 1; 8 14 1; 3 1 1];
        unitCell.perCon=[4 8 1 1;6 10 1 1;1 2 1 1];
        if strcmp(opt.template,'Fig6#a')
            unitCell.Polyhedron(1).solidify=[1,2,3,5,7];
            unitCell.Polyhedron(2).solidify=[2,3,4];
        end
        unitCell.ViewPoint=[-44 30];
    case {'#25'}
        unitCell.Polyhedron(1)=polyhedra('truncated cuboctahedron');
        unitCell.Polyhedron(2)=polyhedra('truncated octahedron');
        unitCell.Polyhedron(3)=polyhedra('cube');
        unitCell.Polyhedron(4)=polyhedra('cube');
        unitCell.Polyhedron(5)=polyhedra('cube');
        unitCell.expCon(1).dir=[1 12 1; 2 18 1; 10 48 1];
        unitCell.expCon(2).dir=[7 4 1; 3 5 1; 8 12 1];
        unitCell.expCon(3).dir=[7 22 1; 8 48 1; 3 21 1];
        unitCell.expCon(4).dir=[3 20 1; 4 43 1; 1 18 1];
        unitCell.perCon=[16 15 1 1;17 18 1 1;13 14 1 1];
        unitCell.ViewPoint=[-58 48];
    case {'#26'}
        unitCell.Polyhedron=polyhedra('hexagonal prism');
        unitCell.perCon=[7 4 1 1; 6 3 1 1; 1 2 1 1];
        opt.A1=-34;
        unitCell.ViewPoint=[-44 30];
    case {'#27'}
        unitCell.Polyhedron(1)=polyhedra('truncated cuboctahedron');
        unitCell.Polyhedron(2)=polyhedra('octagonal prism');
        unitCell.Polyhedron(3)=polyhedra('octagonal prism');
        unitCell.Polyhedron(4)=polyhedra('octagonal prism');
        unitCell.expCon(1).dir=[5 43 1; 9 41 1; 7 42 1];
        unitCell.expCon(2).dir=[3 13 1; 11 5 1; 1 6 1];
        unitCell.expCon(3).dir=[5 26 1; 11 28 1; 7 20 1];
        unitCell.perCon=[24 21 1 1;26 19 1 1;23 22 1 1];
        %         unitCell.ViewPoint=[24 10];
        unitCell.ViewPoint=[-80 13];
    case {'#28','Fig4a'}
        unitCell.Polyhedron=polyhedra('truncated octahedron');
        unitCell.PolyName{1}=['truncated octahedron'];
        unitCell.perCon=[14 11 1 1; 9 8 1 1; 10 7 1 1] ;
        unitCell.ViewPoint=[-117 15];
end
end