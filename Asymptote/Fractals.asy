void sierpinski (picture pic=currentpicture, int n = 5, pair shift=(0,0), real scale=1, pen p=currentpen)
{
    pair a = (cos(pi/2), sin(pi/2));
    pair b = (cos(pi/2 + 2*pi/3), sin(pi/2 + 2*pi/3));
    pair c = (cos(pi/2 + 4*pi/3), sin(pi/2 + 4*pi/3));
    path r = 2*a--2*b--2*c--cycle;
    
    path[] s = new path[1];
    s[0] = r;
    
    for (int i = 0; i < n; ++i)
    {
        path[] s1 = shift(a)*scale(0.49)*s;
        path[] s2 = shift(b)*scale(0.49)*s;
        path[] s3 = shift(c)*scale(0.49)*s;
        s = s1 ^^ s2 ^^ s3;
    }

    draw(pic, shift(shift)*scale(scale)*s, p=p);
}