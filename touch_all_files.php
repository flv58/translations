<?php
/**
 * Toouch all INI files by adding or removing an empty line at their end
 */

class Scanner
{
	public function run($myRoot = null)
	{
		if (is_null($myRoot))
		{
			$myRoot      = __DIR__;
		}

		foreach (new DirectoryIterator($myRoot) as $item)
		{
			if ($item->isDot())
			{
				continue;
			}

			$filePath = $item->getPathname();
			if ($item->isDir())
			{
				$this->run($filePath);

				continue;
			}

			if (!$item->isFile())
			{
				continue;
			}

			if ($item->getExtension() != 'ini')
			{
				continue;
			}

			echo "$filePath\n";
			$this->touch($filePath);
		}
	}

	protected function touch($filePath)
	{
		$contents = file_get_contents($filePath);

		if (substr($contents, -1) == "\n")
		{
			$contents = substr($contents, 0, -1);
		}
		else
		{
			$contents .= "\n";
		}

		// Write the file back
		file_put_contents($filePath, $contents);
	}

}
try
{
	$scanner      = new Scanner();
	$scanner->run();
}
catch (Exception $e)
{
	echo $e->getMessage();
}
