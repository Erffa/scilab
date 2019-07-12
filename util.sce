

/////////////////////////////////////////////////////////////////
// LA FONCTION ETUDIE : EGGHOLDER
/////////////////////////////////////////////////////////////////

function [y]=f_eh(x)
    x1 = x(1)
    x2 = x(2)
    
    //y=-(x2-47)*sin(sqrt(abs(x2+x1/2+47))) - x1*sin(sqrt(abs(x1-(x2+47))))

    y=-(x(2,:)+47).*sin(sqrt(abs(x(1,:)./2 + x(2,:) + 47))) - x(1,:).*sin(sqrt(abs(x(1,:) - x(2,:) - 47)))

    // c'est bon pour le moral
    //y=-20*exp(-.2*sqrt(.5*(x1*x1 + x2*x2)) ) - exp(.5*cos(2*%pi*x1+2*%pi*x2)) + %e + 20
endfunction

B_eh=[-512 512;-512 512];
//B_eh=[-5 5;-5 5];

sol_eh=[512 ; 404.2319];




/////////////////////////////////////////////////////////////////
// CREATION D ECHANTILLON
/////////////////////////////////////////////////////////////////

// Créer un ensemble aléatoire de n vecteurs dans l'espace bornés défini par B
// INPUT
// B : matrice d*2 : bornes de l'ensemble de la forme B=[xmin xmax ; ymin ymax ; ...]
// n : nombre de vecteurs aléatoires créer
// OUTPUT
// X : matrice d*N : ensemble des vecteurs aléatoires créés
function [X]=samp_alea(B,n)
    [d,_]=size(B);
    X=zeros(d,n);
    for li=1:d do
        X(li,:)=B(li,1)+(B(li,2)-B(li,1))*rand(1,n);
    end
endfunction

// Créer un ensemble aléatoire de n points dans l'espace bornés défini par B respectant
// les conditions d'un carré latin : même espacement selon coords, coordonnées uniques
// INPUT
// B : matrice d*2 : bornes de l'ensemble de la forme B=[xmin xmax ; ymin ymax ; ...]
// n : nombre de vecteurs aléatoires créer
// OUTPUT
// X : matrice d*N : ensemble des vecteurs aléatoires créés
function [X]=LatinHypercube(B,n)
    [d,_]=size(B);
    X=zeros(d,n);
    for li=1:d do
        X(li,:) = samwr( n , 1 , linspace(B(li,1),B(li,2),n) )';
    end
endfunction


function test_LatinHypercube()
    n=5;
    B=[0 10 ; 0 5];
    LH=LatinHypercube(B,n);

    clf
    gca().tight_limits=['on','on'];
    gca().data_bounds= [B(1,1)-1 B(2,1)-1 ; B(1,2)+1 B(2,2)+1];
    gca().isoview='on';
    gca().auto_scale='off';


    plot(LH(1,:),LH(2,:), "+");
    for i=1:n do
        // ligne horizontale
        plot( B(1,:) , [LH(2,i),LH(2,i)] );
        // ligne verticale
        plot( [LH(1,i),LH(1,i)] , B(2,:) );
    end
endfunction


////////////////////////////////////////////////////
// DDELETE TOUS LES TAGS
////////////////////////////////////////////////

// Permet de supprimer tous les éléments graphiques d'un certain tag
// INPUT 
// tag : le tag rechercher
function destroy(tag)
    f = findobj(tag);
    while f<>[] do
        delete(f);
        f=findobj(tag);
    end
endfunction

/////////////////////////////////////////////////////////////////
// CALCUL DE LA PSO
/////////////////////////////////////////////////////////////////
// RECHERCHE MINIMUM
////////////////////////////


function [a,b] = mincol(x,f)
    [n,m]=size(x)
    a=x(:,1)
    b=1
    for i = 1:m
        if f(a) > f(x(:,i))  then
            a=x(:,i)
            b=i
        end
    end
endfunction

function [a,b] = mincol_abs(x,f)
// 
    [n,m]=size(x)
    a=x(:,1)
    b=1
    for i = 1:m
        if abs(f(a)) > abs(f(x(:,i)))  then
            a=x(:,i)
            b=i
        end
    end
endfunction

/////////////////////////////////////
// CRITERE CONVERGENCE
////////////////////////////

// Calcul le centre gravité d'un nuage de points P de poids W
// INPUT
// P : matrice d*n : les n vecteurs colonnes de dim d
// W : matrice 1*n : les poids des vecteurs
// OUTPUT
// G : matrice d*1 : position du centre de gravité
function G=GravityCenter(P,W)   
    // somme des poids
    p=sum(W)
    // pondération des points
    Ppond=P*diag(W)
    // somme pondérée
    sumPond=sum(Ppond,"c")
    // moyenne pondere
    G=sumPond/p
endfunction

// Calculer le cercle de centre le centre de gravité d'un nuage de point et qui
// encercle tous les points
// INPUT
// P : matrice d*n : les n vecteurs de dim d à encercler
// OUTPUT
// G : matrice d*1 : position du centre de gravité
// r : rayon du cercle entourant tous les points
function [G,r]=Surround(P)
    // 
    [d,n]=size(P)
    
    // définit le centre de masse
    // par défaut, poids à 1 -> donner masse plus importante aux sols proches ?
    W=ones(n,1)
    G=GravityCenter(P,W)
    
    // on calcule la distance (carré entre les points et le centre du cercle à la recherche 
    // de la distance maximale, qui donnera rayon cercle
    // R2 : liste des rayons au carré
    dif = P-kron(ones(1,n),G)
    R2 = sum(dif.*dif, "r")
    
    r = sqrt(max(R2)) 
endfunction


//////////////////////////////////////
// BORNER LES POINTS
//////////////////////////

// x : matrice d,n : les n points de dimensions d à borner
// b : matrice d,2 : pour chaque coef, la borne inf et sup
function bx=bound_x(x,b)
    bx=x
    [d,n]=size(bx)
    for li=1:d do
        bx(li,:)=min(b(li,2),max(b(li,1),bx(li,:)))
    end
endfunction


