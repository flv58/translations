#!/usr/bin/env bash
#
# @package    translations
# @copyright  (c) 2010-2017 Akeeba Ltd
# @license    GNU GPLv3 or, at your option, any later version published by the Free Software Foundation
#
# Create a weblate.json file for importing all of the language components into Weblate
#

php ../buildfiles/tools/fix-weblate-language-files.php -r `pwd`

