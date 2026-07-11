function export_surf2rhino(x, y, aperture, normals, h_0, ismin)
    dist_beam = distance_Z(aperture, normals, h_0);
    
    if ismin
        [dist, ~] = min (dist_beam);
    else
        [dist, ~] = max (dist_beam);
    end
    z = reshape(dist, size(sqrt(aperture)));

    [fileName, pathName] = uiputfile({'*.txt', 'Rhino script file (*.txt)'}, 'Export lens surface to Rhino');
    
    if fileName ~= 0
        fileName = [pathName, fileName];
        fid = fopen(fileName, 'w');
        
        if fid > 1    
            resStr = [];
            for j = 1 : size(x,2)
                resStr = [resStr '_Polyline\n'];
                for i = 1 : size(x,1)
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