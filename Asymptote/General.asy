import math;
import three;
import graph;
import contour;
import geometry;
import drawtree;
import roundedpath;
import labelpath;
// import babel;
// import solids;
// import obj;
// import node;
settings.render=8;
settings.prc=false;

// currentpen = linewidth(1pt);

real eps = 0.0001;

void test(pen p = red + linewidth(2pt)){draw((0,0)--(1,1), p);}

void test_3(pen p = red + linewidth(2pt)){dot(O, p);}

real arr_max (real[] A)
{
    real x = A[0];
    
    for(int i = 1; i < A.length; ++i){if (x < A[i]){x = A[i];}}
    
    return x;
}

real arr_min (real[] A)
{
    real x = A[0];

    for(int i = 1; i < A.length; ++i){if (x > A[i]){x = A[i];}}
    
    return x;
}

pair path_middle (path p, int n = 20)
{
    pair sum = (0,0);

    for (int i = 0; i < n; ++i)
    {
        sum += point(p, length(p)*i/n);
    }

    return sum/n;
}

path full_graph (picture pic=currentpicture, real f(real) = exp,
real x1=-1, real x2=1, real xmargin=0.5, real ymargin=0.7,
bool drawaxis=true, bool displaynumbers=true,
bool displayleftnumber=true, bool displayrightnumber=true,
pen axispen=currentpen, pen plotpen=currentpen+blue+cyan, bool smooth=true,
bool drawdashes=true, bool drawleftdash=true,
bool drawrightdash=true, bool draweq=true,
align align=E, align leftnumberalign = S,
align rightnumberalign=S, string graphlabel = "$y = e^x$",
int n=1000, arrowbar axisarrow = Arrow(SimpleHead), bool drawzero = true)
{
    if (drawaxis)
    {
        int n = 10;
        real d = (x2-x1)/n;
        real[] A = new real[n+1];
        for (int i = 0; i <= n; ++i){A[i] = f(x1 + i*d);}
        real y1 = min(arr_min(A), 0);
        real y2 = max(arr_max(A), 0);
        pair a1 = (x1-xmargin, 0);
        pair a2 = (x2+xmargin, 0);
        pair b1 = (0, y1-ymargin);
        pair b2 = (0, y2+ymargin);
        label(pic, "$x$", a2, align = E);
        label(pic, "$y$", b2, align = N);
        draw(pic, a1 -- a2, p=axispen, axisarrow);
        draw(pic, b1 -- b2, p=axispen, axisarrow);
    }
    
    path tickup = (0,0)--(0, 0.15cm);
    path tickdown = (0,0)--(0, -0.15cm);
    
    if (displaynumbers)
    {
        if (displayleftnumber)
            {
                Label ticklabel1 = Label((string)x1, position=EndPoint, align=leftnumberalign);
                
                if (f(x1) >= 0){draw((x1,0), pic, tickdown, 
                L=ticklabel1);}
                else{draw((x1,0), pic, tickup, L=ticklabel1);}
            }
        if (displayrightnumber)
            {
                Label ticklabel2 = Label((string)x2, position=EndPoint, align=rightnumberalign);
                
                if(f(x2) >= 0){draw((x2,0), pic, tickdown, L=ticklabel2);}
                else{draw((x2,0), pic, tickup, L=ticklabel2);}
            }
    }
    
    if (drawzero) {label("0", (0,0), align = S+W);}
    
    path s;
    
    if (drawdashes)
    {
        if (drawleftdash){draw(pic, (x1,0) -- (x1, f(x1)), dashed);}
        if (drawrightdash){draw(pic, (x2,0) -- (x2, f(x2)), dashed);}
    }

    if (smooth) {s = graph(f, x1, x2, operator ..);}
    else {s = graph(f, x1, x2, n = n);}
    
    draw(pic, s, p=plotpen);
    
    if(draweq){label(pic, graphlabel, (x2, f(x2)), align=align);}
    
    return s;
}

void draw_coords (picture pic = currentpicture, int x = 10, int y = 10, real ticksize = .5, int step = 1, pen textpen = fontsize(12pt))
{
    draw(pic, (-x, 0)--(x,0));
    draw(pic, (0, -y)--(0,y));

    for(int i = -x; i <= x; i += step){
        if(i != 0)
        {
            draw((i, ticksize/2)--(i, -ticksize/2), L = Label((string)i, position = EndPoint, align = S), textpen);
        }
    }

    for(int i = -y; i <= y; i += step)
    {
        if(i != 0)
        {
            draw((ticksize/2, i)--(-ticksize/2, i), L = Label((string)i, position = EndPoint, align = W), textpen);
        }
    }
}

void draw_xyz (picture pic = currentpicture, real s, pen p = currentpen, arrowbar3 arrow = Arrow3())
{
    draw(pic=pic, -s*X--s*X, p=p, L=Label("$x$", position = EndPoint), arrow=arrow);

    draw(pic=pic, -s*Y--s*Y, p=p, L=Label("$y$", position = EndPoint), arrow=arrow);

    draw(pic=pic, -s*Z--s*Z, p=p, L=Label("$z$", position = EndPoint), arrow=arrow);
}

real l (pair a) {return sqrt(a.x*a.x+a.y*a.y);}

void draw_implicit (picture pic=currentpicture, real f(real, real), pair a, pair b)
{
    guide[][] thegraphs = contour(f, a, b, new real[] {0});

    draw(pic, thegraphs[0]);
}

void draw_shifted(path g, pair trueshift, picture pic =
currentpicture, Label label="", pen pen=currentpen,
arrowbar arrow=None, arrowbar bar=None, margin
margin=NoMargin, marker marker=nomarker)
{
    pic.add(new void(frame f, transform t)
    {
        picture opic;
        draw(opic, L=label, shift(trueshift)*t*g, p=pen,
        arrow=arrow, bar=bar,
        margin=margin, marker=marker);
        add(f,opic.fit());
    });

    pic.addBox(min(g), max(g), trueshift+min(pen), trueshift+max(pen));
}

void add_clip (picture pic=currentpicture, path p, real scale=1, pair shift=(5,0))
{
    picture g;
    g=pic;

    pair mid = path_middle(p);
    
    clip(g, p);
    
    g=shift(shift)*scale(scale)*shift(-mid)*g;
    
    pic.add(g);
}

path[] tick_equal_segment (pair a, pair b, int n = 1, real length = .5, real distance = .05)
{
    path[] res = new path[n];

    pair t;

    if (a.y == b.y) {t = (0,1);}
    else {t = (1, -(b.x-a.x)/(b.y-a.y));}

    pair m = (a+b)/2;

    pair v = unit(b-a)*distance;

    for (int i = 0; i < n; i += 1)
    {
        res[i] = ((m+(i-((n-1)/2))*v)-unit(t)*length)--((m+(i-((n-1)/2))*v)+unit(t)*length);
    }

    return res;
}

bool contains (int i, int[] l) 
{
    for (int i = 0; i < l.length; ++i)
    {
        if (l[i] == i) {return true;}
    }
    return false;
}

picture draw_w_function (string[] l, int[] t = new int[], int mode, pen p = blue+.5)
{
    picture q;
    path[] res = new path[l.length];
    int dmode = mode;
    draw(pic = q, (0, 0)--(l.length+1, 0));
    
    for (int i = 0; i<l.length; ++i)
    {   
        label(pic=q, ((dmode==1) ? "\Large{$+$}" : "\Large{$-$}"), (i+0.5,dmode/7));

        if (contains(i,t) == true) 
        {   
            label(pic=q,l[i], (i+1, 0), (0, -dmode));
            res[i]=(i+0.5,dmode*2/7){E}..{E}(i+1,0){E}..{E}(i+1.5,dmode*2/7);


        } else 
        {   
            label(pic=q,l[i], (i+1, 0), (-dmode, -1));

            res[i]=(i+0.5,dmode*2/7){E}..{(1,-dmode)}(i+1,0){1,-dmode}..{E}(i+1.5,-dmode*2/7);
            dmode=-dmode; 

        }
    }

    label(pic=q, ((dmode==1) ? "\Large{$+$}" : "\Large{$-$}"),(l.length+0.5,dmode/7));


    path s = res[0];
    
    for (int i=1; i < l.length; ++i) {s = s..res[i];}

    draw(pic=q,s,p);


    for (int i=1; i <= l.length; ++i) 
    {
        dot(pic=q,(i,0));
    }

    return q;
}