% :- type parcMutató ==    int-int.          % egy parcella helyét meghatározó egészszám-pár
% :- type fák ==           list(parcMutató). % a fák helyeit tartalmazó lista
% :- type irány    --->    n                 % észak 
%                        ; e                 % kelet 
%                        ; s                 % dél   
%                        ; w.                % nyugat
% :- type iránylista ==    list(irany).      % egy adott fához rendelt sátor
                                             % lehetséges irányait megadó lista
% :- type iránylisták ==   list(iránylista). % az összes fa iránylistája

% :- pred iranylistak(parcMutató::in         % NM
%                     fák::in,               % Fs
%                     iránylisták::out)      % ILs
					     
% :- pred sator_szukites(fák::in,            % Fs
%                        int::in,            % I
%                        iránylisták::in,    % ILs0
%                        iránylisták::out)   % ILs
:- use_module(library(lists)).

sator_szukites(Fs, I, ILs0, ILs):-
    nth1(I,Fs,F),
    nth1(I,ILs0,IL0),
    length(IL0,1),
    conv_h(F,IL0,K),
    each_elem(I,Fs,ILs0,K,ILs1),
    non_empty(ILs1,ILs,ILs1).
    
    
each_elem(_,[],[],_,[]). 
each_elem(1,[_|TFs],[HIL|ILs0T],K,[H|TILs]):-
    H = HIL,
    each_elem(0,TFs,ILs0T,K,TILs).
each_elem(I,[XF-YF|TFs],[ILs0H|ILs0T],KX-KY,[HILs|TILs]):-
    
    \+ I = 1,
    each_sky(XF-YF,ILs0H,KX-KY,HILs),
    I1 is I-1,
    each_elem(I1,TFs,ILs0T,KX-KY,TILs).
    
each_sky(_,[],_,[]).
each_sky(XF-YF,[H|T],KX-KY,TILs):-
    conv(XF-YF,H,K1-K2),
    V1 is K1-KX,
    V2 is K2-KY,
    bennevan(V1-V2),
    each_sky(XF-YF,T,KX-KY,TILs).
each_sky(XF-YF,[H|T],KX-KY,[Hs|Ts]):-
    Hs = H,
    conv(XF-YF,H,K1-K2),
    V1 is K1-KX,
    V2 is K2-KY,
	\+ bennevan(V1-V2),
    each_sky(XF-YF,T,KX-KY,Ts).
   
bennevan(V1-V2):-
    V1 >= -1,
    V1 =< 1,
    V2 >= -1,
    V2 =< 1.

conv_h(F,[ILs0|_],K):-
    conv(F,ILs0,K).

iranylistak(N-M, Fs, ILs):-
  fa(N-M, Fs, Fs, ILs1),
  non_empty(ILs1,ILs,ILs1).

non_empty([],ILs,ILs1):-
  ILs = ILs1.
non_empty([[]|_],ILs,_):-
    ILs = [].
non_empty([Z|T],ILs,ILs1):-
    Z \= [],
    non_empty(T,ILs,ILs1).

fa(_, [], _, []).
fa(N-M, [HF|TF], Fs, [I|L]):-
    conv(HF,e,K1),
    foglalt(N-M,K1,Fs,e,V1),
	conv(HF,n,K2),
    foglalt(N-M,K2,Fs,n,V2),
    append(V1, V2, R1),
    conv(HF,s,K3),
    foglalt(N-M,K3,Fs,s,V3),
    append(R1, V3, R2),
    conv(HF,w,K4),
    foglalt(N-M,K4,Fs,w,V4),
    append(R2, V4, I),
    fa(N-M, TF, Fs, L).

foglalt(N-M,F,[], E, K):-
    inside(N-M,F),
    K = [E].
foglalt(_,F,[F|_], _, K):-
    K = [].
foglalt(N-M,F,[Z|TF], E, K):-
    F \= Z,
    foglalt(N-M,F,TF, E, K).
foglalt(N-M,F,[], _, K):-
    \+ inside(N-M,F),
    K = [].   

inside(N-M, Kn-Km) :-
    Km >= 1,
    Km =< M,
    Kn >= 1,
    Kn =< N.

conv(HI,n,K) :-
    X-Y = HI,
    X2 is X-1,
    K = X2-Y.
    
conv(HI,w,K) :-
    X-Y = HI,
    Y2 is Y-1,
    K = X-Y2.

conv(HI,s,K) :-
    X-Y = HI,
    X2 is X+1,
    K = X2-Y.

conv(HI,e,K) :-
    X-Y = HI,
    Y2 is Y+1,
    K = X-Y2.