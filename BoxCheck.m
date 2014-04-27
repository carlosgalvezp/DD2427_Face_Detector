function check = BoxCheck(x,y,w,h,W,H)
    check = 0;
    if x<1 || y <1
        disp('[ComputeBoxSum]: Invalid (x,y) coordinates');        
        return;
    elseif y+h-1 > H || x+w-1 > W
        disp('[ComputeBoxSum]: Invalid (w,h)');
        return;
    end
    check = 1;
end