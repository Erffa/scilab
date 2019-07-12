

///////////////////////////////////////////////////////////////////////////////////
// SETTERS DE TEXTES
///////////////////////////////////////////////////////

function callback_editOmega(app)
    app.txt_lbl3_omega.String = "ω = "+string(app.slider_omega.Value);
endfunction

function callback_editAlpha(app)
    app.txt_lbl_option_alpha.String="α : "+string(app.slider_alpha.Value);
endfunction

function callback_editBeta(app)
    app.txt_lbl_option_beta.String = "β : "+string(app.slider_beta.Value);
endfunction


function callback_editN(app)
    val = round(app.slider_n.Value);
    app.slider_n.Value=val;
    app.txt_n.String = "n : "+string(val);
endfunction

// ...................................

function callback_editMaxite(app)
    val = round(app.slider_maxite.Value);
    app.slider_maxite.Value=val;
    app.txt_maxite.String = "max ité. : "+string(val);
endfunction

function callback_editDt(app)
    app.txt_dt.String = "dt : "+string(app.slider_dt.Value);
endfunction

function callback_editPrec(app)
    val = round(app.slider_prec.Value);
    app.slider_prec.Value=val;
    app.txt_prec.String = "précision :  1e-"+string(val);
endfunction


///////////////////////////////////////////////////////////////////////////////////
// POUR RADIOBUTTONS
///////////////////////////////////////////////////////

// choix du type de x0
function callback_setTypeX0(app, code)
    // mise à zéro
    set(app.rb_x0_alea, 'Value', 0);
    set(app.rb_x0_lsqr, 'Value', 0);
    // sélection du bon radiobutton
    select code
    case 1 then
        set(app.rb_x0_alea, 'Value', 1);
    case 2 then
        set(app.rb_x0_lsqr, 'Value', 1);
    else
        disp("mucho problemo")
    end
endfunction

// choix du type de v0
function callback_setTypeV0(app, code)
    // mise à zéro
    set(app.rb_v0_alea, 'Value', 0);
    set(app.rb_v0_zero, 'Value', 0);
    // sélection du bon radiobutton
    select code
    case 1 then
        set(app.rb_v0_alea, 'Value', 1);
    case 2 then
        set(app.rb_v0_zero, 'Value', 1);
    else
        disp("mucho problemo")
    end
endfunction

// -------------------------------------------------------------

// choix du type de Omega
function callback_setTypeOmega(app, code)

    set(app.rb_omega_cnst, 'Value', 0);
    set(app.rb_omega_rand, 'Value', 0);
    set(app.rb_omega_atan, 'Value', 0);

    select code
    case 1 then
        set(app.rb_omega_cnst, 'Value', 1);
    case 2 then
        set(app.rb_omega_rand, 'Value', 1);
    case 3 then
        set(app.rb_omega_atan, 'Value', 1);
    else
        disp('Error !!!!!');
    end
endfunction

// choix du type de Alpha et Beta
function callback_setTypeAb(app, code)

    set(app.rb_ab_cnst, 'Value', 0);
    set(app.rb_ab_atan, 'Value', 0);

    select code
    case 1 then
        set(app.rb_ab_cnst, 'Value', 1);
    case 2 then
        set(app.rb_ab_atan, 'Value', 1);
    else
        disp('Error !!!!!');
    end
endfunction

// ---------------------------------------------------------------------

// choix de la fonction étudiée
function select_rb(num)

    // on sélectionne uniquement le dernier radiobutton pressé
    // déselction de tous les radiobuttons
    for rb=app.list_rb do
        set(rb,'value',0);
    end
    // selection du radiobutton pressé
    set(app.list_rb(num),'value',1);

    // affichage de la valeurs du(des) minimum(s) attendue
    res=evstr('res'+string(num));
    set(app.txt_res_va, 'String',"Vraie valeur : "+string(res));

    /* */
    // Affichage de(s) position(s) solution(s)
    sol=evstr('sol'+string(num));
    [nsol,d]=size(sol);
    str="[";
    str=str+string(sol(1,1))+" "+string(sol(1,2));
    for li=2:nsol do
        str=str+" ; "+string(sol(li,1))+" "+string(sol(li,2));
    end
    str=str+"]";
    set(app.txt_res_pa, 'String',"Vraie position : "+str);
    // */
    
    // on redessine le relief couleur
    drawlater()
    // supprime les points résiduels et la colormap precedente
    destroy('scatter_x');
    destroy('Sgrayplot');
    // on redessine
    colorise_2(app);
    drawnow()
endfunction



///////////////////////////////////////////////////////////////////////////////////
// PBOUTON START
///////////////////////////////////////////////////////

function callback_start(app)

    // ~~~~~~~~~~~~~~~~~~~~~~
    // PREMIERES PRECAUTION ~
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // on empêche l'utilisateur de réappuyer sur bouton pdt période de simulation
    app.pb_start.Enable='off';
    // pour les fonctions aussi ??? choix de prioirté ???

    // efface le tracé precedent de la precision
    destroy('plot_prec');
    destroy('scatter_x');
    
    // ?? essaye de arreter action
    //stop=%F
    
    
    // ~~~~~~~~~~~~~~~~
    // INITIALISATION ~
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
    // from CHOIX DE L'ECHANTILLON
    // nombre de points
    n = app.slider_n.Value;
    // création du x0
    select app.type_x0
    case 1 then
        x=samp_alea(app.B,n);
    case 2 then
        x=LatinHypercube(app.B,n);
    else
        disp("valeur non reconnue pour type_x0");
        return;
    end
    // création de v0
    select app.type_v0
    case 1 then
        V0=1; // influe sur distance v0 peut parcourir 
        v=V0.*(1-2*rand(2,n));
    case 2 then
        v=zeros(2,n);
    else
        disp("valeur non reconnue pour type_v0");
        return;
    end
    
    // from AUTRES VARIABLES
    // nombre maximale d'itérations
    maxite = app.slider_maxite.Value;
    // precision recherché (critère  d'arrêt)
    e=10^-(app.slider_prec.Value); //1e-5
    // le 'pas' : dt
    dt = app.slider_dt.Value;
    
    
    // les graphes où dessiner
    polplot=findobj('polplot')
    pelote=findobj('pelote')
    
    // on update taille du graph qui plot omega,alpha,beta
    pelote.data_bounds=[0 0 ; maxite 1.6];


    // STOCKAGE DES MEILLEURS
    // liste des meilleurs individuels
    P=x;
    // le meilleur des meilleurs
    [g,_] = mincol(P,app.funct);
    // pour calcul : colonnes de g
    G=kron(ones(1,n),g);


    // on fixe le type de omega choisit pour cette tentative
    typeomega=app.typeomega;
    // on fixe le type de alpha,beta choisit pour cette tentative
    typeab=app.typeab;
    
   
    // VALEURS DES SLIDERS SI CHOIX CONSTANT
    omega_sl = app.slider_omega.Value;
    alpha_sl = app.slider_alpha.Value;
    beta_sl  = app.slider_beta.Value;
   
    // LES CRITèRES D ARRET
    [centre,rayon]=Surround(x);
    k=1;

    //while k<maxite & r>e & ~stop do
    while k<maxite & rayon>e do
        
        /////////////////////////////////////////////////////////////////////////////////////////
        // ALGO 
        ///////////////////////////////////////////////////////////////////

        // CALCUL DES OMEGA, ALPHA et BETA
        // calcul de omega
        select typeomega
        case 1 then
            omega=omega_sl;
        case 2 then
            omega=(2-2*k/maxite)*diag(rand(n,1));
        // atan
        case 3 then
            omega=calc_o(k, maxite);
        else
            disp("valeur inconnue pour typeomega");
            return;
        end

        // calcul de alpha et beta
        select typeab
        case 1 then
            alpha = alpha_sl;
            beta_ = beta_sl;
        case 2 then
            [alpha,beta_]=calc_ab(k, maxite);
        else
            disp("valeur inconnue pour typeab");
            return;
        end
        
        
        // CALCUL POSITION ET VITESSE SUIVANTE
        //[x,v, P,g,G, centre,rayon]=doStep(d,n, x,v, P,g,G, app.funct, dt, omega,alpha,beta_, app.B);
        // hugo
        //[x0,x,v0,v, P,g,G, centre,rayon]=doStep_(x0,x,v0,v, P,g,G, app.funct,dt, alpha,beta_,omega, app.B)
        
        
        //
        C1=diag(alpha*rand(1,n));
        C2=diag(beta_*rand(1,n));
        //
        v=v*omega+ (P-x)*C1 + (G-x)*C2
        x=bound_x(x+dt*v, app.B);
        
        
        // CALCUL DES MEILLEURS
        // individuels
        for i = 1:n do
            if app.funct(P(:,i))-app.funct(x(:,i))>0 then
                P(:,i)=x(:,i)
            end
        end
        // globale
        g=mincol(P,app.funct)
        G=kron(ones(1,n),g)
        
        [centre,rayon]=Surround(x);
        
        /////////////////////////////////////////////////////////////////////////////////////////
        // DESSIN 
        ///////////////////////////////////////////////////////////////////
        
        drawlater();
        // on efface précédent et on dessine nouveaux
        destroy('scatter_x');
        sca(polplot);
        scatter(x(1,:) , x(2,:) , 10, 'black', '+');
        gce().tag='scatter_x';
        //

        // dessin de l évolution de omega, alpha et beta
        sca(pelote);
        //
        omegaga=omega(1,1);
        plot(k,omegaga, "ro-");
        gce().tag='plot_prec';
        plot(k,alpha, "go-");
        gce().tag='plot_prec';
        plot(k,beta_, "bo-");
        gce().tag='plot_prec';
        legend(['omega';'alpha';'beta']);
        //

        //......................................;..........................

        
        
        /*
        plot( [k,k,k] ,[omega, alpha, beta_], [1 2 3] ); //["ro-","go-","bo-"]
        gce().tag='plot_prec';

        
        plot(k,omega, "ro-");
        gce().tag='plot_prec';
        plot(k,alpha, "go-");
        gce().tag='plot_prec';
        plot(k,beta_, "bo-");
        gce().tag='plot_prec';
     
        legend(['omega';'alpha';'beta']);

        //fg=app.funct(g);
        //plot(k,fg, "+");
        //gce().tag='plot_prec';
        // */


        drawnow();
        
        // next step
        app.txt_res_ni.String="Nombre d''itérations :"+string(k);
        app.txt_res_pp.String="Meilleure position : [ "+string(g(1))+" ; "+string(g(2))+" ]";
        app.txt_res_vp.String="Meilleure valeur : "+string(app.funct(g));
        
        k=k+1
        sleep(10);
    end
    
    //if stop then
    //    disp("arret d urgence")
    //    return
    //end

    // pause bienfaitrice
    sleep(50)
    
    // on réactive le bouton
    app.pb_start.Enable='on'
endfunction

//
//function callback_stop(handles)
//    stop=%T
//endfunction
//


