<?php
function convert_translations($translationRoot, $sourceRoot)
{
	if (basename($sourceRoot) == 'en-GB')
	{
		$translationRoot = dirname($translationRoot) . '/el-GR';

		if (!is_dir($translationRoot))
		{
			mkdir($translationRoot, 0755, true);
		}

		// TODO Process language files
		$di = new DirectoryIterator($sourceRoot);

		foreach ($di as $file)
		{
			if (!$file->isFile())
			{
				continue;
			}

			if ($file->getExtension() != 'ini')
			{
				continue;
			}

			$sourcePath     = $file->getPathname();
			$translatedPath = $translationRoot . '/' . str_replace('en-GB', 'el-GR', $file->getBasename());

			// Load both files
			$sourceStrings      = load_language($sourcePath);
			$translatedStrings  = load_language($translatedPath);
			$translatedContents = load_file($translatedPath);

			// Find missing keys
			$sourceKeys = array_keys($sourceStrings);
			$translatedKeys = array_keys($translatedStrings);
			$missingKeys = array_diff($sourceKeys,$translatedKeys);

			if (empty($missingKeys))
			{
				continue;
			}

			// Append a marker indicating missing strings
			$marker = ';; New untranslated strings (please delete this line when you are done)';
			$hasMarker = strpos($translatedContents, $marker) !== false;

			if (!$hasMarker)
			{
				$translatedContents .= "\n\n" . $marker . "\n\n";
			}

			// Append missing keys
			foreach ($missingKeys as $key)
			{
				$translatedContents .= ';' . $key . '="' . str_replace('"', '\"', $sourceStrings[$key]) . "\"\n";
			}

			// Write back the $translatedPath file
			file_put_contents($translatedPath, $translatedContents);
		}

		return;
	}

	// If I am still here it's a branch node.
	$di = new DirectoryIterator($sourceRoot);

	foreach ($di as $folder)
	{
		if ($folder->isDot())
		{
			continue;
		}

		if (!$folder->isDir())
		{
			continue;
		}

		$newTransRoot = $translationRoot . '/' . $folder->getFilename();
		convert_translations($newTransRoot, $folder->getPathname());
	}
}

function load_language($file): array
{
	if (!file_exists($file) || !is_readable($file))
	{
		return [];
	}

	return parse_ini_file($file, false);
}

function load_file($file): string
{
	if (!file_exists($file) || !is_readable($file))
	{
		return '';
	}

	return file_get_contents($file);
}

$mySource = realpath(__DIR__ . '/..');

$di = new DirectoryIterator($mySource);

foreach ($di as $folder)
{
	if (!$folder->isDir())
	{
		continue;
	}

	if ($folder->isDot())
	{
		continue;
	}

	$bareName           = $folder->getFilename();
	$sourceTranslations = $mySource . '/../' . $bareName . '/translations';

	if (!is_dir($sourceTranslations))
	{
		continue;
	}

	convert_translations($folder->getPathname(), $sourceTranslations);
}