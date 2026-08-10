function export_surf2rhino(n, m, structure, h_0)
    
    aperture = structure.aperture;
    normals = structure.normals;
    ismin = structure.ismin;

    dist_beam = distance_Z(aperture, normals, h_0);
    
    if ismin
        [dist, ~] = min (dist_beam);
    else
        [dist, ~] = max (dist_beam);
    end

    %s = sqrt(length(dist));
    x_size = -n/2: n/(n-1) :n/2;
    y_size = -m/2: m/(m-1) :m/2;
    [x, y] = meshgrid(x_size, y_size);
    z = reshape(dist(1:(n*m)), n, m);

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