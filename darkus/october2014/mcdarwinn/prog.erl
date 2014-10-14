-module(prog).
-export([main/0]).

main() ->
	
	
	{ok, [Num]} = io:fread("Prompt> ","~d"),
	

	printAllMatrix(Num).


printAllMatrix(N) ->
	io:write(N),
	io:format("~n~n"),

	Size = round(N/2),
	StartSequence = createList(Size*Size),
	

	iterateSequence(StartSequence, Size).



printMatrix([]) -> ok;

printMatrix([Head|Tail]) ->
	printMatrixLine(array:to_list(Head)),
	io:format("~n"),
	printMatrix(Tail);

printMatrix(Matrix) ->
	
	List = array:to_list(Matrix),
	printMatrix(List),
	io:format("~n")

	.


printMatrixLine([]) -> ok;

printMatrixLine([Head|Tail]) -> 
	io:write(Head),
	printMatrixLine(Tail)
	.



printSequence(Sequence, Size) ->


	EmptyMatrix = createMatrix(Size*2),
	NewMatrix = processSequence(EmptyMatrix, Sequence, 0),
	

	printMatrix(NewMatrix)
	.



processSequence(Matrix, [], _) -> Matrix;

processSequence(Matrix, [Head | Tail], Index) ->

	
	HalfSize = round(array:size(Matrix)/2),

	Points = getPoints(indexToPoint(Index, HalfSize), HalfSize),
	BlackPoint = lists:nth(Head+1, Points),
	%io:write(BlackPoint),
	NewMatrix = setBlackPoint(Matrix, BlackPoint),

	processSequence(NewMatrix, Tail, Index+1)
	.


setBlackPoint(Matrix, {point, X, Y}) ->
	Line = array:get(Y, Matrix),
	NewLine = array:set(X, 1, Line),
	array:set(Y, NewLine, Matrix).

	


indexToPoint(Index, Size) ->
	{point, (Index rem Size), trunc(Index/Size)}
	.

getPoints({point, X,Y}, HalfSize) ->	
	[
		{point, X, Y},
		{point, HalfSize+(HalfSize-1)-Y, X},
		{point, HalfSize+(HalfSize-1)-X, HalfSize+(HalfSize-1) - Y},
		{point, Y, HalfSize+(HalfSize-1)-X}

	]
	.



iterateSequence(Sequence, Size) -> 

	printSequence(Sequence, Size),

	[_ | Tail] = Sequence,

	NewSequence = nextSequence(Tail),
	case (NewSequence) of
		err -> ok;
		_ -> iterateSequence([0] ++ NewSequence, Size)
	end
	.

nextSequence([]) -> err;	

nextSequence([Head | Tail]) when Head < 3 -> 
	[Head+1 | Tail];

nextSequence([_| Tail]) ->
	Sub = nextSequence(Tail),

	case Sub of
	  err -> err;
	  _ -> [0] ++ Sub
	end.

	


%createMatrix(Size) -> createMatrix(Size, []).

createMatrix(Size) -> 
	Line = array:new([{size, Size}, {default, 0}]),
	array:new([{size, Size}, {default, Line}])
	.



createList(0) -> [];
createList(N) when N > 0 -> [ 0 | createList( N-1 ) ].