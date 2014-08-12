<?php

/**
 * @since 08.08.14 12:35
 * @author Arsen Abdusalamov duburlan@gmail.com
 */
class RussianPost {

    protected $symbol = [
        0 => [[1, 1, 1],
            [1, 0, 1],
            [1, 0, 1],
            [1, 0, 1],
            [1, 1, 1]],

        1 => [[1, 1, 0],
            [0, 1, 0],
            [0, 1, 0],
            [0, 1, 0],
            [1, 1, 1]],

        2 => [[1, 1, 1],
            [0, 0, 1],
            [1, 1, 1],
            [1, 0, 0],
            [1, 1, 1]],

        3 => [[1, 1, 1],
            [0, 0, 1],
            [1, 1, 1],
            [0, 0, 1],
            [1, 1, 1]],

        4 => [[1, 0, 1],
            [1, 0, 1],
            [1, 1, 1],
            [0, 0, 1],
            [0, 0, 1]],

        5 => [[1, 1, 1],
            [1, 0, 0],
            [1, 1, 1],
            [0, 0, 1],
            [1, 1, 1]],

        6 => [[1, 1, 1],
            [1, 0, 0],
            [1, 1, 1],
            [1, 0, 1],
            [1, 1, 1]],

        7 => [[1, 1, 1],
            [0, 0, 1],
            [0, 1, 1],
            [0, 1, 0],
            [0, 1, 0]],

        8 => [[1, 1, 1],
            [1, 0, 1],
            [1, 1, 1],
            [1, 0, 1],
            [1, 1, 1]],

        9 => [[1, 1, 1],
            [1, 0, 1],
            [1, 1, 1],
            [0, 0, 1],
            [1, 1, 1]]
    ];

    const SYMBOL_WIDTH = 3;

    const SYMBOL_HEIGHT = 5;

    protected $mask = [
        [[10, 9, 9]],
        [[6 ,1, 7]],
        [[8, 9, 9]],
        [[4, 2, 7]],
        [[8, 9, 9]],
    ];

    protected $bigData;

    protected $maxX;

    protected $maxY;

    public function printSymbolAtPos($rowOffset, $colOffset)
    {
        for ($rowNum = 0; $rowNum < self::SYMBOL_HEIGHT; $rowNum++) {
            echo PHP_EOL;
            for ($colNum = 0; $colNum < self::SYMBOL_WIDTH; $colNum++) {
                echo $this->bigData[$rowNum + $rowOffset][$colNum+$colOffset];
            }
        }
        echo "\n======\n\n";
    }

    function __construct($bigData = null)
    {
        if ($bigData) {
            $this->setBigData($bigData);
        }
    }

    public function getBigData()
    {
        return $this->bigData;
    }

    public function setBigData($bigData)
    {
        $this->bigData = $bigData;
        $this->maxY = count($bigData);
        $this->maxX = count($bigData[0]);
    }

    /**
     *
     * @param string $filename filename or url
     */
    public function loadBigDataFromRaw($filename)
    {
        $content = file_get_contents($filename);

        $this->setBigData(array_map(function ($line) {
                return str_split($line);
            },
            explode("\n", str_replace("\r", '', $content))
        ));
    }

    public function saveBigdataToRawFile($fileName)
    {
        file_put_contents($fileName, implode("\n",
			array_map(
				function ($row) {
					return implode('', $row);
				},
				$this->bigData
			)
		));
    }

    public function checkPos($x, $y)
    {
        switch (true) {
            case $x > ($this->maxX - self::SYMBOL_WIDTH) && $y > ($this->maxY - self::SYMBOL_HEIGHT):
                return false;
            // all symbols have point at top left corner
            case !$this->bigData[$y][$x]:
                return false;

            // all symbols have 2 or 3 point in top line
            case ($this->bigData[$y][$x+1] + $this->bigData[$y][$x + 2]) == 0:
                return false;
        }

        foreach ($this->symbol as $currentSymbol => $symbol) {
            $flag = true;
            foreach ($symbol as $rowNum => $row) {
                foreach ($row as $colNum => $point) {
                    if ($point != $this->bigData[$rowNum+$y][$colNum+$x]) {
                        $flag = false;
                        break 2;
                    }
                }
            }
            if ($flag) {
                return $currentSymbol;
            }
        }
        return false;
    }

    public function checkAll()
    {
        $result = [];
        for ($rowNum = 0; $rowNum < ($this->maxY - self::SYMBOL_HEIGHT); $rowNum++) {
            for ($colNum = 0; $colNum < ($this->maxX - self::SYMBOL_WIDTH); $colNum++) {
                $symbol = $this->checkPos($colNum, $rowNum);
                if ($symbol !== false) {
                    echo "Symbol $symbol at [$rowNum, $colNum]\n";
                    $result[] = [$symbol, $colNum, $rowNum];
                }
            }
        }
        return $result;
    }
}
if (empty($argv[1])) {
    die("usage: \nphp {$argv[0]} input.txt\n OR \nphp {$argv[0]} http://some.url/raw/input\n\n");
}

$russianPost = new RussianPost();
$rawDataInput = $argv[1];

$russianPost->loadBigDataFromRaw($rawDataInput);

$russianPost->checkAll();

