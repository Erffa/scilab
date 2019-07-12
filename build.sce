

///////////////////////////////////////////////////////////////////////////
// CONSTRUCTION FENETRE
///////////////////////////////////////////////////////////////////////////

function [app]=build_gui(app)

    // pour faire des jonctions propres
    eps=0.01;
    
    // Construction des éléments graphiques

    // ??????????????????????
    //f.immediate_drawing="off";

    // Valeurs par défaut
    DEFAULT_N=100;
    
    DEFAULT_MAXITE=100;
    DEFAULT_DT=1;
    DEFAULT_PREC=4;
    
    DEFAULT_NUMFUNCT=3;
    
    
    DEFAULT_TYPEOMEGA=1;
    DEFAULT_OMEGA=1;
    
    DEFAULT_TYPEAB=1;
    DEFAULT_ALPHA=0.6;
    DEFAULT_BETA =1.4;
    
    

    // créationd de la figure, élément de base
    app.fig = figure(...
        'tag','fig', ...
        'figure_name','my app', ...
        'figure_position',[0,0], ...
        'figure_size',[1200,600], ...
        'background',[31], ...
        'auto_resize','on', ...
        'default_axes','off', ...
        'dockable','off', ...
        'infobar_visible','off', ...
        'toolbar_visible','off', ..
        'menubar_visible','off', ...
        'visible','off');


    // LES FRAMES
    // frame de gauche pour option sur la pso
    frame1=build_frame(app.fig, 'frame1', [ 0 0 , .25 1], [.5 .8 .9]);
    // frame pour affichage des points
    frame2=build_frame(app.fig, 'frame2', [.25 0 , 0.375 1], [.5 .8 .9]);
    // frame pour afficher les résultat
    frame3=build_frame(app.fig, 'frame3', [.625 0 , .375, 1], [.5 .8 .9]);


    ///////////////////////////////////////////////////////////////////////////////
    // FRAME 1 
    ///////////////////////////////////////////////////////////////////

    // titres
    txt_title_sample=create_text(frame1, 'txt_title_sample', "CHOIX DE L''ECHANTILLON", [0 .90 , 1 .1]);
    txt_title_other =create_text(frame1, 'txt_title_other',  "AUTRES VARIABLES",        [0 .55 , 1 .1]);
    txt_title_funct =create_text(frame1, 'txt_title_funct',  "CHOIX DE LA FONCTION",    [0 .30 , 1 .1]);
    
    // ~~~~~~~~~~~~~~~~~~~~~~~
    // ECHANTILLON DE DEPART ~
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // choix position de départ
    // texte
    txt_sample_x0=create_label(frame1, 'txt_sample_x0', "choix x0",[0,.8 , .4 .1+eps]);
    // radiobuttons
    app.rb_x0_alea=create_radiobutton(frame1, 'rb_x0_alea', 'Aléatoire', ...
        'callback_setTypeX0(app, 1);app.type_x0=1', [.4,.85, .6,.05+eps]);
    app.rb_x0_lsqr=create_radiobutton(frame1, 'rb_x0_lsqr', 'Carré latin', ...
        'callback_setTypeX0(app, 2);app.type_x0=2', [.4,.80, .6,.05+eps]);
        
    // choix vitesse de départ
    // texte
    txt_sample_v0=create_label(frame1, 'txt_sample_v0', "choix v0",[0,.7 , .4 .1+eps]);
    // radiobuttons
    app.rb_v0_alea=create_radiobutton(frame1, 'rb_v0_alea', 'Aléatoire', ...
        'callback_setTypeV0(app, 1); app.type_v0=1', [.4,.75, .6,.05+eps]);
    app.rb_v0_zero=create_radiobutton(frame1, 'rb_v0_zero', 'Nulle', ...
        'callback_setTypeV0(app, 2); app.type_v0=2', [.4,.70, .6,.05+eps]);
        
    // choix nombre de points
    // texte
    app.txt_n=create_label(frame1, 'txt_n', 'n : '+string(DEFAULT_N), [0 .65 , .4 .05+eps]);
    // slider
    app.slider_n=create_slider(frame1, 'slider_n', 0, 1000, [1,50], DEFAULT_N, ...
        'callback_editN(app)', [.4 .65, .6 .05+eps]);
    
        
    // choix par défaut
    callback_setTypeX0(app, 2);
    app.type_x0=2;
    
    callback_setTypeV0(app, 2);
    app.type_v0=2;
        
        
    // ~~~~~~~~~~~~~~~~
    // AUTRES OPTIONS ~
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
    // choix du maximum d'itération
    app.txt_maxite=create_label(frame1, 'txt_maxite', 'max ité. : '+string(DEFAULT_MAXITE), [0 .5, .4 .05]);
    // slider
    app.slider_maxite=create_slider(frame1, 'slider_maxite', 0, 1000, [1,50], DEFAULT_MAXITE, ...
        'callback_editMaxite(app)', [.4 .5, .6 .05]);
    
    // choix du dt
    // texte
    app.txt_dt=create_label(frame1, 'txt_dt', 'dt : '+string(DEFAULT_DT), [0 .45 , .4 .05]);
    // slider
    app.slider_dt=create_slider(frame1, 'slider_dt', 0, 1, [.01 .1], DEFAULT_DT, ...
        'callback_editDt(app)', [.4 .45, .6 .05]);
    
    // choix du dt
    // texte
    app.txt_prec=create_label(frame1, 'txt_prec', 'précision : 1e-'+string(DEFAULT_PREC), [0 .4 , .4 .05]);
    // slider
    app.slider_prec=create_slider(frame1, 'slider_prec', 1, 10, [1 1], DEFAULT_PREC, ...
        'callback_editPrec(app)', [.4 .4, .6 .05]);
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    

    // ~~~~~~~~~~~~~~~~
    // CHOIX FONCTION ~
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // titre
    txt_title_funct=create_text(frame1, 'txt_title_funct', "CHOIX DE LA FONCTION", [.05 .3 , .9 .1]);
    // frame pour radio buttons
    fr_rb=build_frame(frame1, 'fr_rb', [ 0 0 , 1 .3], [.6,.8,.6]);
    // radiobuttons
    // créations des radiobuttons
    for num=0:14 do
        // 
        strnum=string(num+1);
        //
        li=int(num/3);
        co=int( (num-li*3) );
        li=li+1;
        //
        rb=create_radiobutton(fr_rb, 'rb_funct_'+strnum, evstr('name'+strnum), ...
            'app.funct=f'+strnum+';app.B=B'+strnum+';select_rb('+strnum+');', ...
            [co/3 1-li/5 , 1/3 1/5+.01]);

        app.list_rb=cat(1, app.list_rb, rb);
    end
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    ///////////////////////////////////////////////////////////////////////////////
    // FRAME 2
    ///////////////////////////////////////////////////////////////////

    // création du plan
    fr_polplot=build_frame(frame2, 'fr_polplot', [ 0 .3 , 1 .7], [.5 .7 .8]);
    newaxes(fr_polplot);  
    gce().tag='polplot';
    sca(gce());
    // choix du titre
    xtitle("Evolution d'' un groupe de point à la recherche d'' un minimum"); 
    // colorise la zone
    colorise_2(app);

    // ~~~~~~~~~~~~~~
    // BoUTON START ~
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    app.pb_start=uicontrol( ...
        frame2, ...
        'Tag','pb_start',...
        'unit','normalized', ...
        'Enable','on', 'Visible','on', ...
        'Position',[.1 .25 , .8.05], ...
        'Style','pushbutton', ...
        'Relief','ridge', ...
        'String','start', ...
        'FontAngle','normal','FontSize',[18], 'FontName','xx', ...
        'FontUnits','pixels', 'FontWeight','demi', ...
        'HorizontalAlignment','center', 'VerticalAlignment','middle', ...
        'BackgroundColor',[.09,.8,.9], 'ForegroundColor',[.0,.2,.25], ...
        'Callback','callback_start(app)');
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    // ~~~~~~~~~~~~~~~~
    // INFO RECHERCHE ~
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // les zones de texte dynamiques 
    frame_info=build_frame(frame2, 'frame_info', [.05 0 , .9 .25], [.5 .8 .9]);
    app.txt_res_ni=create_text(frame_info, 'txt_res_ni', 'Nombre d''itérations : ', [.05 4/5, .9 1/5]);
    app.txt_res_pp=create_text(frame_info, 'txt_res_pp', 'Meilleure position : ', [.05 3/5 , .9 1/5+eps]);
    app.txt_res_vp=create_text(frame_info, 'txt_res_vp', 'Meilleure valeur : ', [.05 2/5 , .9 1/5+eps]);
    app.txt_res_pa=create_text(frame_info, 'txt_res_pa', 'Vraie position : ', [.05 1/5 , .9 1/5+eps]);
    app.txt_res_va=create_text(frame_info, 'txt_res_va', 'Vraie valeur : ', [.05 0 , .9 1/5+eps]);
    
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
    ///////////////////////////////////////////////////////////////////////////////
    // FRAME 3
    ///////////////////////////////////////////////////////////////////
    
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // GRAPHE DE OMEGA, ALPHA ET BETA ~
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    frame_prec=build_frame(frame3, 'frame_prec', [.0 0.4 , 1 .6], [.6 .5 .9]);
    newaxes(frame_prec);
    gce().tag='pelote';
    sca(gce());
    xtitle("évolution des coefficients avec les itérations")
    gca().tight_limits=['on','on']
    gca().data_bounds=[0 0 ; DEFAULT_MAXITE 1.6];
    gca().auto_scale='off';
    xgrid(2);
    
    
    // ~~~~~~~~~~~~~~~~~~~~~~~~
    // CHOIX ALPHA BETA OMEGA ~
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    frame_oab=build_frame(frame3, 'frame_prec', [0 0 , 1 .4], [.9 .5 .9]);
    frame_o  =build_frame(frame_oab, 'frame_o',  [ 0 0 , .5 1], [.2 .9 .9]);
    frame_ab =build_frame(frame_oab, 'frame_ab', [.5 0 , .5 1], [.1 .5 .9]);
    
    // ~~~~~~~~~~~~~
    // CHOIX OMEGA ~
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // titre
    txt_title_omega=create_text(frame_o, 'txt_title_omega', "CHOIX DE OMEGA", [0 .75 , 1 .25]);
    // choix type d'omega
    // texte
    txt_lbl1_omega=create_label(frame_o, 'txt_to1', 'Type d''omega : ',[0 .25 , .4 .5]);
    // radiobuttons
    frame_rb_omega=build_frame(frame_o, 'frame_rb_omega', [.4 .25 , .6 .5], [.9 .5 .9]);
    app.rb_omega_cnst=create_radiobutton(frame_rb_omega, 'rb_omega_cnst', 'Constant', ...
        'callback_setTypeOmega(app, 1); app.typeomega=1; app.frame_om1.Visible=''on'';',  [0 .666 , 1 .334]);
    app.rb_omega_rand=create_radiobutton(frame_rb_omega, 'rb_omega_rand', 'Aléatoire', ...
        'callback_setTypeOmega(app, 2); app.typeomega=2; app.frame_om1.Visible=''off'';', [0 .333 , 1 .334]);
    app.rb_omega_atan=create_radiobutton(frame_rb_omega, 'rb_omega_atan', 'Arctan', ...
        'callback_setTypeOmega(app, 3); app.typeomega=3; app.frame_om1.Visible=''off'';', [0    0 , 1 .334]);
    // frame option omega : le frame qui apparait quand 1 selectionné
    // le frame
    app.frame_om1=build_frame(frame_o, 'frame_om1', [ 0 0 , 1 .25], [.6,.6,.3]);
    // labal pour slider
    app.txt_lbl3_omega=create_label(app.frame_om1, 'txt_lbl3_omega', 'ω = 1', [0 0 , .4 1]);
    // le slider
    app.slider_omega = create_slider(app.frame_om1, 'slider_omega', 0, 1, [.01,.1], 1, 'callback_editOmega(app)', [.4 0 , .6 1]);
    
    // valeur par défaut
    app.rb_omega_cnst.Value=1;
    app.typeomega=1;
     //app.frame_om1.Visible='off';
    
    // ~~~~~~~~~~~~~~~~~
    // CHOIX ALPHA BETA ~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // titre
    txt_title_ab=create_text(frame_ab, 'txt_title_ab', "CHOIX DE ALPHA ET BETA", [0 .75 , 1 .25])
    // choix type d'omega
    // texte
    txt_lbl1_a=create_label(frame_ab, 'txt_lbl1_a', 'Type d''alpha',[0 .50 , .4 .25]);
    txt_lbl1_b=create_label(frame_ab, 'txt_lbl1_b', 'et beta : ',   [0 .25 , .4 .25]);
    // radiobuttons
    frame_rb_ab=build_frame(frame_ab, 'frame_rb_ab', [.4 .25 , .6 .5], [.9 .5 .9]);
    app.rb_ab_cnst=create_radiobutton(frame_rb_ab, 'rb_ab_cnst', 'Constants', ...
        'callback_setTypeAb(app, 1); app.typeab=1; app.frame_option_ab.Visible=''on'';',  [0 .5 , 1 .5]);
    app.rb_ab_atan=create_radiobutton(frame_rb_ab, 'rb_ab_atan', 'Arctan', ...
        'callback_setTypeAb(app, 2); app.typeab=2; app.frame_option_ab.Visible=''off'';', [0  0 , 1 .5]);
    // frame option omega : le frame qui apparait quand 1 selectionné
    // le frame
    app.frame_option_ab=build_frame(frame_ab, 'frame_option_ab', [ 0 0 , 1 .25], [.6,.6,.3]);
    // labal pour slider
    app.txt_lbl_option_alpha=create_label(app.frame_option_ab, 'txt_lbl_option_alpha', 'α = '+string(DEFAULT_ALPHA), [0 .5 , .4 .5]);
    app.txt_lbl_option_beta =create_label(app.frame_option_ab, 'txt_lbl_option_beta',  'β = '+string(DEFAULT_BETA) , [0  0 , .4 .5]);
    // le slider
    app.slider_alpha = create_slider(app.frame_option_ab, 'slider_alpha', 0, 2, [.01,.1], DEFAULT_ALPHA, 'callback_editAlpha(app)', [.4 .5 , .6 .5]);
    app.slider_beta  = create_slider(app.frame_option_ab, 'slider_beta',  0, 2, [.01,.1], DEFAULT_BETA,  'callback_editBeta(app)',  [.4  0 , .6 .5]);
    
    // valeur par défaut
    app.rb_ab_cnst.Value=1;
    app.typeab=1;
     //app.frame_om1.Visible='off';
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
    // ~~~~~~~~~~~~~~~~~~~~~
    // CVALEURS PAR DEFAUT ~
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // set pour la fonction 3
    app.funct=f3;
    app.B=B3;
    select_rb(3);
    // */
endfunction



////////////////////////////////////////////////////////////////////////////////////////////
// COLORISER LE PLAN
//////////////////////////////////////////////////////////////////////////////////////////////

// Colorie la surface de la zone définie par B selon la fonction funct.
// Utilisé à l'initialisation et à chaque changement de fonction.
function colorise_2(this)
    drawlater()

     // DEFINITIONS DE LA ZONE A COLORIER
    // largeur et longueur
    w=this.B(1,2)-this.B(1,1);
    h=this.B(2,2)-this.B(2,1);
    // calcul precision coloriage
    s=min(w,h)/this.color_prec;
    nx=int(w/s);
    ny=int(h/s);
    // les valeurs en x et y à colorier
    x=linspace(this.B(1,1),this.B(1,2), nx);
    y=linspace(this.B(2,1),this.B(2,2), ny);
    // calcul de la valeur de la fonction en chaque points
    z = zeros(nx,ny);
    for i=1:nx
        for j=1:ny
            z(i,j) = this.funct( [x(i);y(j)] );
        end
    end

    // DESSIN SUR LE PLAN
    // limite des axes X Y
    sca(findobj('polplot'));
    a=gca()
    a.tight_limits=['on','on']
    a.data_bounds=this.B'
    a.isoview='on'
    a.auto_scale='off'

    // choix du dégradé de couleur
    xset("colormap",jetcolormap(64));

    // dessin des couleurs
    Sgrayplot(x,y,z);
    gce().tag='Sgrayplot';

    // DESSIN DU COLORBAR
    // calcul du min et max pour créer l'échelle de valeur
    zm = min(z); zM = max(z);
    
    // construction de la barre latérale de légende
    // - destruction du précédent
    f=findobj('colorbar');
    while f<>[] do
        delete( f.parent );
        f=findobj('colorbar');
    end
    // - reset de la taille du frame pour éviter réduction de la largeur
    gca().axes_bounds=[0 0 , 1 1];
    // - création de la nouvelle échelle de couleur
    colorbar(zm,zM);
    gce().tag='colorbar';
    drawnow();
endfunction
