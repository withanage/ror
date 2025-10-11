<?php
/**
 * @file classes/ArticleView.php
 *
 * @copyright (c) 2021+ TIB Hannover
 * @copyright (c) 2021+ Gazi Yücel
 * @license Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class ArticleView
 * @brief Article View
 */

namespace APP\plugins\generic\ror\classes;

use APP\plugins\generic\ror\RorPlugin;
use APP\template\TemplateManager;
use Exception;
use PKP\core\Core;
use PKP\plugins\Hook;

class ArticleView
{
    /** @var RorPlugin */
    private RorPlugin $plugin;

    /** @param RorPlugin $plugin */
    public function __construct(RorPlugin $plugin)
    {
        $this->plugin = $plugin;
    }

    /**
     * Show Ror ID on front page of article.
     *
     * @param string $hookName
     * @param array $args
     * @return bool
     * @throws Exception
     */
    function execute(string $hookName, array $args): bool
    {
        $request = $args[0];
        $templateMgr = TemplateManager::getManager($request);

        $icon = '';
        $iconPath = Core::getBaseDir() . '/' . $this->plugin->getPluginPath() . '/' . Constants::iconPath;

        if (file_exists($iconPath)) $icon = file_get_contents($iconPath);

        $templateMgr->assign([Constants::iconNameInTemplate => $icon]);

        return Hook::CONTINUE;
    }
}
