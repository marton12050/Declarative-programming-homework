% :- type parcMutató ==   int-int.          % egy parcella helyét meghatározó egészszám-pár
% :- type fák        ==   list(parcMutató). % a fák helyeit tartalmazó lista
% :- type irány    --->   n                 % észak 
%                       ; e                 % kelet 
%                       ; s                 % dél   
%                       ; w.                % nyugat
% :- type sHelyek    ==   list(irany).      % a fákhoz tartozó sátrak irányát megadó lista
% :- type bool       ==   int               % csak 0 vagy 1 lehet
% :- type boolMx     ==   list(list(bool)). % a sátrak helyét leíró 0-1 mátrix

% :- pred satrak_mx(parcMutató::in,         % NM
%                   fák::in,                % Fs
%                   sHelyek::in,            % Ss
%                   boolMx::out).           % Mx

satrak_mx(X, Fs, Ss, Mx):-
  M-N = X,
  numlist(1,M,L),
  egymas(Fs,Ss,SF),
  all_unique(SF),
  inside(X,Fs,Ss),
  row(N, Fs, Ss,L,Mx).

numlist(N, M, []):- 
  M =:= N-1.

numlist(N, M, [N|Seq]):- 
  M >= N,
  N1 is N+1,
  numlist(N1, M, Seq).


all_unique(L) :-
  sort(L,R),
  length(L,N),
  length(R,N).

egymas([],[], []).
egymas([Fs|TFs],[Ss|TSs], [SF|TSF]) :-
    conv(Fs,Ss,SF),
    egymas(TFs,TSs,TSF).

row(_,_, _,[],[]).
row(N,Fs, Ss,[HM|TM],[HRow|TRow]):-
  length(HRow,N),
  numlist(1,N,Nindex),
  elem_helper(Fs, Ss,HM,Nindex,HRow),
  row(N,Fs, Ss,TM,TRow).

elem_helper(_, _,_,[],[]).
elem_helper(Fs, Ss,HM,[Nindex|TNindex],[HRow|THRow]) :-
    elem(Fs, Ss,HM,Nindex,HRow),
    elem_helper(Fs, Ss,HM,TNindex,THRow).

elem( [], _, _, _, El):-
  El=0.
elem( [HI|_], [HS|_], M, N,El):-
  conv(HI,HS,K),
  M-N = K,
  El=1.

elem( [HI|TI], [HS|TS], M, N,El):-
  conv(HI,HS,K),
  M-N \= K,
  elem(TI, TS,M,N,El).

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
    
inside(N-M,[HF|HT], [HS|TS]) :-
    conv(HF,HS,Kn-Km),
    Km >= 1,
    Km =< M,
    Kn >= 1,
    Kn =< N,
    inside(N-M,HT, TS).

inside(_,[], []).


