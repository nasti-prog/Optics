function export_surf2rhino(n, m, structure, h_0, size_aper)
    
    normals = structure.normals;
    ismin = structure.ismin;

    x_size = -size_aper/2: size_aper/(n-1) :size_aper/2;
    y_size = -size_aper/2: size_aper/(m-1) :size_aper/2;      
    [x, y] = meshgrid(x_size, y_size);                    
    aperture_new = [x(:), y(:)];

    dist_beam = distance_Z(aperture_new, normals, h_0);
    
    if ismin
        [dist, ~] = min (dist_beam);
    else
        [dist, ~] = max (dist_beam);
    end

    s = sqrt(length(dist));
    z = reshape(dist, s, s);

    [fileName, pathName] = uiputfile({'*.txt', 'Rhino script file (*.txt)'}, 'Export lens surface to Rhino');
    
    if fileName ~= 0
        fileName = [pathName, fileName];
        fid = fopen(fileName, 'w');
        
        if fid > 1    
            resStr = [];
            for j = 1 : size(x, 2)
                resStr = [resStr '_Polyline\n'];
                for i = 1 : size(x, 1)
                    resStr = [resStr sprintf('%f,%f,%f\n', x(i, j), y(i, j), z(i, j))];
                end
                resStr = [resStr '_Enter\n'];
            end
            fprintf(fid, resStr);
            % fprintf(fid, "_SelCrv\n");
            % fprintf(fid, "-_Patch _PointSpacing=1  _USpans=40  _VSpans=40  _Stiffness=1  _AdjustTangency=Yes  _AutomaticTrim=Yes _EnterEnd\n");
            % fprintf(fid, "_Delete\n");

            fclose(fid);
        end
    end
end