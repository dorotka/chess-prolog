
% ----------- startingPosition(BOARD) ------------

startingPosition(B) :- 
	B = [
		[white(rook), white(knight), white(bishop), white(queen), white(king), white(bishop), white(knight), white(rook)],
		[white(pawn), white(pawn), white(pawn), white(pawn), white(pawn), white(pawn), white(pawn), white(pawn)],
		[blank, blank, blank, blank, blank, blank, blank, blank],
		[blank, blank, blank, blank, blank, blank, blank, blank],
		[blank, blank, blank, blank, blank, blank, blank, blank],
		[blank, blank, blank, blank, blank, blank, blank, blank],
		[black(pawn), black(pawn), black(pawn), black(pawn), black(pawn), black(pawn), black(pawn), black(pawn)],
		[black(rook), black(knight), black(bishop), black(queen), black(king), black(bishop), black(knight), black(rook)]
	]. 


% --------- 1. fileConversion(X, Y) -----------

fileConversion(a, 1).
fileConversion(b, 2).
fileConversion(c, 3).
fileConversion(d, 4).
fileConversion(e, 5).
fileConversion(f, 6).
fileConversion(g, 7).
fileConversion(h, 8).



% --- 2. getOccupier(BOARD,File,Rank,Occupier) ---

getOccupier(BOARD,File,Rank,Occupier) :- 
	nth1(Rank,BOARD, Row),
	fileConversion(File, Column),
	nth1(Column, Row, Occupier).



% --- 3. setOccupier(BOARD,File,Rank,Occupier, NEWBOARD) ---


% Steps explanation:
	% get the row
	% remove element from the positoin
	% insert the Occupier at the position 
	% replace the old row with the new one


remove(XS,Order,YS) :-
   append(H,[_|T],XS),
   length([_|H],Order),
   append(H,T,YS), !.

setOccupier(BOARD,File,Rank,Occupier, NEWBOARD) :- 
	nth1(Rank,BOARD, Row),
	fileConversion(File, Column),
	remove(Row, Column, Row2),
	nth1(Column, NewRow, Occupier, Row2),
	remove(BOARD, Rank, Board2),
	nth1(Rank, NEWBOARD, NewRow, Board2), !.



%--------------- 4. kingCorrect(B) --------------------


% Steps explanation:
	% for each row
	% find black king and add count to BlackTotal
	% find white king and add count to WhiteTotal
	% if both totals are 1, then true, otherwise false


count([],0).
count([_|T], N) :- count(T, N1), N is N1 + 1.

countKings(_, [], N, N1) :- N1 = N.
countKings(KingAtom, [H|T], N, N1) :-
	findall(X, (member(X, H), X==KingAtom), YS),
	count(YS, C),
	M is N + C, 
	countKings(KingAtom, T, M, N1), !.

kingCorrect(Board) :- 
	countKings(black(king), Board, 0, Black),
	countKings(white(king), Board, 0, White),
	(White == 1, Black == 1) -> true; false.



% ---- 5. movePiece(B1, FileFrom, RankFrom, FileTo, RankTo, NB) -----

% Steps explanation:
	% Get fromOccupier and make sure it is not blank
	% Get toOccupier and make sure they are different color
	% Set new occupier in new square, and old square to balnk


areDifferentColor(P1, P2) :- 
	functor(P1, F1, _),
	functor(P2, F2, _),
	F1 \== F2 -> true ; false.

movePiece(B1, FileFrom, RankFrom, FileTo, RankTo, NB) :-
	getOccupier(B1,FileFrom,RankFrom,OccupierFrom),
	OccupierFrom \== blank,
	getOccupier(B1,FileTo,RankTo,OccupierTo),
	areDifferentColor(OccupierFrom, OccupierTo),
	setOccupier(B1,FileTo,RankTo,OccupierFrom, B2),
	setOccupier(B2,FileFrom,RankFrom, blank, NB).



% ----- displayBoard(X) ----

displayBoard(B) :- print(B).
