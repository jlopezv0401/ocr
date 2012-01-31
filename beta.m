function beta_cal=beta(x,y)
switch (x)
    case 0
        switch (y)
            case 0
                salida=0;
            case 1
                salida=0;
            otherwise
            error(['El segundo parametro solo acepta valores 1 y 2']);
        end
    case 1
        switch (y)
            case 0
                salida=0;
            case 1
                salida=1; 
            otherwise
            error(['El segundo parametro solo acepta valores 1 y 2']);
        end
    case 2
        switch (y)
            case 0
                salida=1;
            case 1
                salida=1;
            otherwise
            error(['El segundo parametro solo acepta valores 1 y 2']);
        end
    otherwise
        error(['El primer parametro solo acepta valores 1, 2 y 3']);
end
beta_cal=salida;