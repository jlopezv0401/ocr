function [fl re]=lines(im_texto)
im_texto=cortar(im_texto);
% figure, imshow(im_texto)
num_filas=size(im_texto,1);
for s=1:num_filas
    if sum(im_texto(s,:))==0
        nm=im_texto(1:s-1, :);%Primera linea
        rm=im_texto(s:end, :);%Lineas Restantes
        fl = cortar(nm);
        re=cortar(rm);
        break
    else
        fl=im_texto;%Solo una linea
        re=[ ];
    end
end

function img_out=cortar(img_in)
[f c]=find(img_in);
img_out=img_in(min(f):max(f),min(c):max(c));%Corta la imagen