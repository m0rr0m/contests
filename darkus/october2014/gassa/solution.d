import std.stdio;
import std.range;

void solve (int n)
{
	int m = n / 2;
	auto board = new char [] [] (n, n);
	foreach (i; 0..n)
	{
		board[i][] = '.';
	}

	void recur (int row, int col)
	{
		if (col >= m)
		{
			col = 0;
			row++;
			if (row >= m)
			{
				writefln ("%(%-(%s%)\n%)\n", board);
				return;
			}
		}

		void go (int crow, int ccol)
		{
			board[crow][ccol] = 'x';
			recur (row, col + 1);
			board[crow][ccol] = '.';
		}

		go (row, col);

		if (row == 0 && col == 0)
		{
			return;
		}

		go (n - row - 1, col);
		go (row, n - col - 1);
		go (n - row - 1, n - col - 1);
	}

	recur (0, 0);
}

void main ()
{
	int n;
	readf (" %s", &n);
	solve (n);
}
