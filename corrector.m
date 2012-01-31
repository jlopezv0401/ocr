function z=corrector(palabra)

    h=actxserver('word.application');
    h.Document.Add;
    % h.CheckGrammar('Las cosas habian llegada lan lrjos para el')
    correcto = h.CheckSpelling(palabra);

    if correcto
        sugerencias=0; %Si es correcto no regresa nada
    else
    %Si es incorrecto regresa una celda con las sugerencias
        if h.GetSpellingSuggestions(palabra).count > 0
            sugerencias = h.GetSpellingSuggestions(palabra).count;
            for i = 1:sugerencias            
                sugerir{i} = h.GetSpellingSuggestions(palabra).Item(i).get('name');
            end
        else
        %Sin Sugerencias
            sugerencias=0;
        end
    end
    %Cerrar Word
    h.Quit
    %Seleccionar la primera sugerencia
    if sugerencias>0
        for i = 1:sugerencias 
            if length(palabra)==length(sugerir{i})
                corregido=sugerir{i}
                return;
            else          
                corregido=palabra;
            end
        end
    else
        corregido=palabra;
    end
    
%     if sugerencias==1 
%         corregido=sugerir{i};
%     else
%         corregido=palabra;
%     end
    
z=corregido;