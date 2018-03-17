<?php
/**
 * This script fixes common issues in language files:
 * - Commented out language strings (leftovers from Transifex)
 * - When Weblate imports INI files it converts COM_FOO="language string" to COM_FOO=""_QQ_"language string"_QQ_""
 *
 * This script must run ONLY locally and THEN push the lang strings to GitHub. Otherwise Weblate does not know it has to
 * re-read the language files from disk :@
 */

class Scanner
{
	private $cliOptions;

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
			$this->removeQuotes($filePath);
			$this->removeComments($filePath);
		}
	}

	/**
	 * Fix strings enclosed by double quote and QQ, e.g.
	 * ""_QQ_"Weblate did a stupid thing"_QQ_""
	 *
	 * @param  string  $filePath  The INI file to process
	 */
	protected function removeQuotes($filePath)
	{
		$contents = file_get_contents($filePath);

		// Do I even have to process this file?
		if (strpos($contents, '"_QQ_"') === false)
		{
			return;
		}

		$lines = explode("\n", $contents);
		$result = '';

		foreach ($lines as $line)
		{
			$line = trim($line);
			$isComment = substr($line, 0, 1) == ';';
			$isLanguageKey = strpos($line, '=') !== false;

			if (empty($line) || $isComment || !$isLanguageKey)
			{
				$result .= $line . "\n";

				continue;
			}

			list($key, $value) = explode('=', $line, 2);

			// Remove surrounding double quotes
			if (substr($value, 0, 1) == '"')
			{
				$value  = substr($value, 1);
			}

			if (substr($value, -1) == '"')
			{
				$value  = substr($value, 0, -1);
			}

			// Remove surrounding "_QQ_" (the Weblate bug)
			if (substr($value, 0, 6) == '"_QQ_"')
			{
				$value  = substr($value, 6);
			}

			if (substr($value, -6) == '"_QQ_"')
			{
				$value  = substr($value, 0, -6);
			}

			// Replace inline escaped double quote \" with single double quote
			$value = str_replace('\\"', '"', $value);

			// Replace inline old-style "_QQ_" with double quote "
			$value = str_replace('"_QQ_"', '"', $value);

			// Normalize inline double quotes to escaped double quotes
			$value = str_replace('"', '\\"', $value);

			// Construct and add the line
			$result .= $key . '="' . $value . "\"\n";

			// Someone managed to cock up so badly that we ended up with escaped \"_QQ_\" in some files...
			$result = str_replace('="\"_QQ_\"', '="', $result);

			$result = rtrim($result, "\n");

			if (substr($result, -9) == '\"_QQ_\""')
			{
				$result = substr($result, 0, -9) . '"';
			}

			$result .= "\n";
		}

		$result = rtrim($result, "\n");

		// If the contents didn't change we won't touch the file, avoiding an expensive reread of the file by Weblate.
		if ($result == $contents)
		{
			return;
		}

		echo "\tFixed \"_QQ_\" enclosure\n";

		// Write the file back
		file_put_contents($filePath, $result);
	}

	/**
	 * Removes commented out language strings, leftovers from Transifex
	 *
	 * @param  string  $filePath  The INI file to process
	 */
	protected function removeComments($filePath)
	{
		$contents = file_get_contents($filePath);

		// Do I even have to process this file?
		if (strpos($contents, '; COM_') === false)
		{
			return;
		}

		$lines = explode("\n", $contents);
		$result = '';

		foreach ($lines as $line)
		{
			$line = trim($line);
			$isComment = substr($line, 0, 1) == ';';

			if (empty($line) || !$isComment)
			{
				$result .= $line . "\n";

				continue;
			}

			$comment = trim($line, ";\n\t ");

			if (substr($comment, 0, 4) != 'COM_')
			{
				$result .= $line . "\n";

				continue;
			}

			// If we're here it's a useless commented out language string so let's just skip it
		}

		$result = rtrim($result, "\n");

		// If the contents didn't change we won't touch the file, avoiding an expensive reread of the file by Weblate.
		if ($result == $contents)
		{
			return;
		}

		echo "\tFixed useless commented out language string\n";

		// Write the file back
		file_put_contents($filePath, $result);
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
