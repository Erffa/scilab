
/////////////////////////////////////////////////////////////////
// LA ARCTAN A LA PICASSO
/////////////////////////////////////////////////////////////////

function [y]=killatan(x, v1,v2, k1,k2)
    if k1==k2 then
        y = v1+(v2-v1)*(x>k1);
    else
        a=(v2-v1)/(k2-k1);
        b=v1-a*k1;
        y = max( min(v1,v2) , min( max(v2,v1), a*x+b ) )
    end
endfunction


function test_killatan()
    // les k 
    maxite=100;
    k=1:maxite;
    // valeurs de omegas selon atan
    omegas_atan=.5-(0.4/(%pi/3))*atan(-maxite/2+k);
    omegas_pica=killatan(k, 1.1,-0.1, 40,55);

    clf()
    xtitle("Approximation d''un atan par une rampe");
    plot(k, [omegas_atan', omegas_pica']);
endfunction


//////////////////////////////////////
// ALGO PSO
//////////////////////////
// CALCUL ALPHA BETA OMEGA
/////////////////////////////////


function [omega,alpha,beta_]=calc_oab(k, maxite)
    omega=.5-(0.4/(%pi/2))*atan(-maxite/2+k);
    alpha= 1-(0.5/(%pi/2))*atan(-maxite/2+k);
    beta_= 1+(0.5/(%pi/2))*atan(-maxite/2+k);
endfunction

function [alpha,beta_]=calc_ab(k, maxite)
    alpha= 1-(0.5/(%pi/2))*atan(-maxite/2+k);
    beta_= 1+(0.5/(%pi/2))*atan(-maxite/2+k);
endfunction

function [omega]=calc_o(k, maxite)
    omega=.5-(0.4/(%pi/2))*atan(-maxite/2+k);
endfunction


function plot_oab(maxite)
    k=1:maxite;
    [omega, alpha, beta_] = calc_oab(k,maxite);

    clf()
    xtitle('Evolution des coefficient au cours des itérations');
    plot(k, [omega', alpha', beta_'], [1 2 3] ); // ['r,'g','b']
    legends(['omega' 'alpha' 'beta'], [1 2 3], opt="lr")
endfunction


///////////////////////
// STEP
//////////////////////
// MY WAY
////////////

/* */
function [x_,v_,P_,g_,G_,centre_,rayon_]=doStep(d,n, x_,v_, P_,g_,G_, f_,dt_, alpha_,beta_,omega_, B)

        

    C1=diag(alpha_*rand(1,n));
    C2=diag(beta_*rand(1,n));

    v_=v_*omega_+ (P_-x_)*C1 + (G_-x_)*C2;
    x_=bound_x(x_+dt_*v_,B);
    
    for i = 1:n do
        if f_(P_(:,i))-f_(x_(:,i))>0 then
            P_(:,i)=x_(:,i)
        end
    end
    
    //cbar = linspace(0,100,100)/100
    g_=mincol(P_,f_)
    G_=kron(ones(1,n),g_)

    // variables de critère d'ar
    k=k+1
    [centre_,rayon_]=Surround(x_)

    //disp(rayon)

endfunction
// */



function [g]=PSO_myway(x,v,f,B,maxite,e)
    
    
    //clf()
    //gca().tight_limits=['on','on'];
    //gca().data_bounds=[LB UB ; LB UB];
    //gca().isoview='on';
    //gca().auto_scale='off';
    

    [d,n]=size(x);

    dt=1
    P=x
    g=mincol(P,f)
    
    G=kron(ones(1,n),g)


    k=1
    [centre,rayon]=Surround(x)

    while k<maxite & rayon>e do

        [omega,alpha,beta_]=calc_oab();

        [x,v, P,g,G, centre,rayon]=doStep(d,n, x,v, P,g,G, f, dt, omega,alpha,beta_, B);
        

        //drawlater()
        //delete( findobj('scat') )
        //scatter(x(1,:),x(2,:),10,"o" )
        //gce().tag='scat'
        //drawnow()
        //sleep(20)
    end
endfunction

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// RHUGO
/////////////////////////////////////////////////////////////////////////////////


function [x0_,x_,v0_,v_,P_,g_,G_,centre_,rayon_]=doStep_(x0_,x_,v0_,v_,P_,g_,G_,f_,t_,alpha_,beta_,omega_,B)
    [centre_,rayon_]=Surround(x_)
    [xsize,nbX]=size(x0_)
    C1=diag(alpha_*rand(1,nbX))
    C2=diag(beta_*rand(1,nbX))

    //x_=born(x0_+t_*v0_,LB,UB)
    x=bound_x(x0_+t_*v0_,B);

    v_=v0_*omega_+ (P_-x_)*C1 + (G_-x_)*C2

    for i = 1: nbX
        if f_(P_(:,i))-f_(x_(:,i))>0 then
            P_(:,i)=x_(:,i)
        end
    end

    //cbar = linspace(0,100,100)/100
    g_=mincol(P_,f_)
    G_=kron(ones(1,nbX),g_)
    x0_=x_
    v0_=v_
    //disp(rayon)
endfunction



function g =PSO_(x0,v0,f,LB,UB,n,e)
    /*
    clf()
    gca().tight_limits=['on','on'];
    gca().data_bounds=[LB UB ; LB UB];
    gca().isoview='on';
    gca().auto_scale='off';
    */
    
    t=1
    C1=1
    C2=1
    x0=born(x0,LB,UB)
    P = x0
    x=x0
    v=v0
    g = mincol(P,f)
    [xsize,nbX]=size(x0)
    G=kron(ones(1,nbX),g)
    k=1
    [centre,rayon]=Surround(x)
    alphas=0.8
    betas=1.2
    omega=0.9    
    //k1_=n/2-floor(n/20)
    //k2_=n/2+floor(n/20)
    /*
    Omega=1-killatan(1:n, 0.1,0.9, k1_,k2_)
    Alphas=1-killatan(1:n, -0.5,0.5, k1_,k2_)
    Betas=killatan(1:n, 0.5,1.5, k1_,k2_)
        */
    while k<n & rayon>e do
        /* */
        //omega=0.5-(0.4/(%pi/2))*atan(-n/2+k)
        //alphas=1-(0.5/(%pi/2))*atan(-n/2+k)
        //betas=1+(0.5/(%pi/2))*atan(-n/2+k)
        /* */
        
        /*
        omega=1-killatan(k, 0.1,0.9, k1_,k2_)
        alphas=1-killatan(k, -0.5,0.5, k1_,k2_)
        betas=killatan(k, 0.5,1.5, k1_,k2_)
        */
        /*
        omega=Omega(k)
        alphas=Alphas(k)
        betas=Betas(k)
        */
        [x0,x,v0,v,P,g,G,centre,rayon] =doStep_(x0,x,v0,v,P,g,G,f,t,alphas,betas,omega)
        /*
        drawlater()
        delete( findobj('scat') )
        scatter(x(1,:),x(2,:),10,"o" )
        gce().tag='scat'
        drawnow()
        */
        //sleep(20)
        k=k+1
        
    end

    /*
    disp("ittérations",k,"il y a eu")
    disp(f(x))
    */
    
    disp(g)
    disp(f(g))
endfunction

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function nbConverge=compteConv(minimumVoulu,eps,tryf)
    n_=100
    LB_=-512
    UB_=512
    x0_=UB_-UB_*rand(2,n_)
    x0latin_=LatinHypercube([LB_ , UB_ ;LB_ , UB_],n_)
    v0_=zeros(2,n_)
    maxite_=75
    nbConverge=0
    for i=1:100
        a=tryf(PSO(x0latin_,v0_,tryf,LB_,UB_,maxite_,eps))
        if norm(minimumVoulu-a)<eps then
            nbConverge=nbConverge+1
            disp("oui")
        end
        disp(i)
    end
endfunction

//disp(compteConv(-959.6407,10^-2,f1))

//test_killatan()

//plot_oab();


/* *
n=100;
B = [-512 512 ; -512 512];
x0_alea =samp_alea(B,n);
x0_latin=LatinHypercube(B,n);
v0=zeros(2,n);
maxite=200;
e=10^-4;
g=PSO(x0_latin,v0, f1, B, maxite,e);
disp("~ ALGO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
disp(g, "g : ");
// */
