close all; clear all; clc;
fid = fopen('basedatos.txt', 'r');
    texto=fread(fid, '*char');    
    texto=strrep(texto', ' ', '');
fclose(fid);

fid = fopen('letra.txt', 'w+');
fprintf(fid,'%s','function calc_letra=regresaLetra(x)');
fprintf(fid,'\n');
fprintf(fid,'%s','switch (x)');
fprintf(fid,'\n');
k=1;
    for i=1:length(texto)        
        caso=strcat('case _', num2str(i));
        fprintf(fid,'\t%s',caso);
        fprintf(fid,'\n');
        letra=strcat('y=''', texto(i), ''';');
        fprintf(fid,'\t\t%s',letra);
        fprintf(fid,'\n');
    end
    
    fprintf(fid,'\t%s','otherwise');
    fprintf(fid,'\n');
    fprintf(fid,'\t\t%s','y=x;');
    fprintf(fid,'\n');    
    
fprintf(fid,'%s','end');
fprintf(fid,'\n');
fprintf(fid,'%s','calc_letra=y;');
fclose(fid);