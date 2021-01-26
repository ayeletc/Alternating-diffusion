dir_name = 'gridSearch_normalized';
accs = {'left','right'};
for i_acc=1:2
    which_acc=accs{i_acc};
    for eps_factor_acc=[10]%[0.01,0.1,1,10,100]
        for eps_factor_frame=[1]%[0.01,0.1,1,10,100]
            for t_win_factor=[5]%[1,2,5]  
                for var_factor=[-4]%[-3,-4]
                    for Lx=[12]%[6,12]
                        Ly = 2*Lx;
                        %% analyze patches in the simulation   
                        imuString       = ['2dSimulation' filesep dir_name filesep 'simulationAcc_' which_acc '.csv'];
                        % videoString     = 'simulationVideo.m4v';
                        videoString     = 'simulationVideo.mp4';
                        file            = ['2dSimulation' filesep dir_name filesep videoString];
                        Nx              = 420;%864;%4482circles_neqAcc_eqR_neqPhase
                        Ny              = 560;%1120;%560;
                        N               = 1000; % 15 [sec]
                        framesMat       = frameExtractor(file, N, Nx, Ny);
                        s0              = 0; % adding 1 later in patchHeatmap
                        f                   = 20; % video frequency
                        numSamplesInWindow  = f/t_win_factor; % number of frames/samples in time window
                        numOfWindows        = N / numSamplesInWindow; % number of time windows = num of heatmaps
                        heatmaps            = zeros(Lx, Ly, numOfWindows);
                        mu_gauss            = 0;
                        var_gauss           = 10^var_factor;
                        for ii = 1:numOfWindows
                            winFramesMat     = framesMat(:,:,1+(ii-1)*numSamplesInWindow : ii * numSamplesInWindow);
                            winFramesMat     = mat2gray(winFramesMat); % normalize to [0,1]
                            winFramesMat     = imnoise(winFramesMat,'gaussian',mu_gauss,var_gauss); % add gaussian noise
                            s0_ii            = s0 + (ii-1) * numSamplesInWindow;
%                             heatmaps(:,:,ii) = patchHeatmap(winFramesMat,s0_ii,numSamplesInWindow,imuString,Lx,Ly,eps_factor_acc,eps_factor_frame);
                            heatmaps(:,:,ii) = patchHeatmap(winFramesMat,s0_ii,numSamplesInWindow,imuString,Lx,Ly);

                        end 

                        %% try double exp
                        frames = zeros(Nx,Ny,size(heatmaps,3));
                        patch_code = [num2str(Lx) num2str(Ly)];
                        for ii=1:size(heatmaps,3)
                            frames(:,:,ii) = imresize(heatmaps(:,:,ii), [Nx,Ny]);
                        end
                        frames = rescale(exp(5.*frames), 0, 1);
                        video = VideoWriter(['2dSimulation' filesep dir_name filesep 'timevar_heatmap_video_' which_acc '_sigma1e' num2str(var_factor) '_twindow' num2str(numSamplesInWindow) 'patch_factor_' patch_code 'epsAcc' num2str(eps_factor_acc) 'epsFrame' num2str(eps_factor_frame) '.avi']); % create the video object
                        video.FrameRate = 5;
                        open(video); % open the file for writing
                        for ii=1:size(frames, 3)
%                             frame = imresize(heatmaps(:,:,ii), [Nx,Ny]);
%                             frame = rescale(exp(5*heatmap), 0, 1);
                            frame = frames(:,:,ii);
                            colorbar;
%                             imshow(frame)
                            writeVideo(video, frame); %write the 'frame to file
                        end
                        close(video);
                    end
                end
            end
        end
    end
end