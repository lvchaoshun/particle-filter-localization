function visualize_pf(map,scale,x,w,observation,mask,selected_particle)

im = mat2gray(map);
im = repmat(im,[1 1 3]);

%%particle display
xx = x;
x(:,1) = x(:,1)/scale(1);
x(:,2) = x(:,2)/scale(2);

x(x(:,1)<0,:) = [];
x(x(:,2)<0,:) = [];
x(x(:,1)>size(map,1),:) = [];
x(x(:,2)>size(map,2),:) = [];

num_bins = uint32(max(max(x) - min(x)));
x = uint32(x);
n = max(hist(double(x(:,1)),double(num_bins)));



%im(:,:,1) = 0;

for i=1:size(x,1)
    
    im(x(i,1),x(i,2),1)  = im(x(i,1),x(i,2),1) + 10*(size(x,1)/n)*w(i);
    %im(x(i,1),x(i,2),2)  = im(x(i,1),x(i,2),2)-10*(size(x,1)/n)*w(i);
    %im(x(i,1),x(i,2),3)  = im(x(i,1),x(i,2),3)-10*(size(x,1)/n)*w(i);
    im(x(i,1),x(i,2),2)  = 0;
    im(x(i,1),x(i,2),3)  = 0;
end
%im(im<0) = 0;
%im(:,:,1) = im(:,:,1).^1/10;
%im(:,:,1) = im(:,:,1)/max(max(im(:,:,1)));

%% robot display
q = [cos(selected_particle(3)/2) 0 0 -sin(selected_particle(3)/2)];
[~,max_index]= max(mask(:,1));
laser_origin = mask(max_index,:);
laser_origin = quatrotate(q,[laser_origin,0]);
laser_origin(:,1) = laser_origin(:,1)/scale(1) + selected_particle(1)/scale(1);
laser_origin(:,2) = laser_origin(:,2)/scale(2) + selected_particle(2)/scale(2);
mask = quatrotate(q,[mask,zeros(size(mask,1),1)]);
mask(:,1) = mask(:,1)/scale(1) + selected_particle(1)/scale(1);
mask(:,2) = mask(:,2)/scale(2) + selected_particle(2)/scale(2);




%% observation display
angles = -pi/2:pi/180:pi/2-pi/180;
r_vec = [cos(angles'),sin(angles'),zeros(size(angles'))];
r_vec = quatrotate(q,r_vec);
r_vec = repmat(observation',1,3).*r_vec;
r_vec(:,1) = r_vec(:,1)/scale(1);
r_vec(:,2) = r_vec(:,2)/scale(2);
r_vec(:,1) = r_vec(:,1) + laser_origin(1);
r_vec(:,2) = r_vec(:,2) + laser_origin(2);
r_vec = [laser_origin;r_vec;laser_origin];


im(im<0) = 0;
im(im>1) = 1;
imshow(im)
hold on
patch(mask(:,1),mask(:,2),'b','FaceAlpha',0.7)
patch(r_vec(:,1),r_vec(:,2),'y','FaceAlpha',0.2);


% use plot to display lines
end