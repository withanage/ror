<?php
/**
 * @file classes/Workflow.php
 *
 * @copyright (c) 2021+ TIB Hannover
 * @copyright (c) 2021+ Gazi Yücel
 * @license Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class Workflow
 * @brief Workflow Publication Contributor
 */

namespace APP\plugins\generic\ror\classes;

use APP\core\Application;
use APP\plugins\generic\ror\RorPlugin;
use APP\template\TemplateManager;
use PKP\plugins\Hook;

class Workflow
{
    /** @var RorPlugin */
    public RorPlugin $plugin;

    /** @param RorPlugin $plugin */
    public function __construct(RorPlugin $plugin)
    {
        $this->plugin = $plugin;
    }

    /**
     * Lookup functionality on Contributor > Edit
     *
     * @param string $hookName
     * @param array $args [string, TemplateManager]
     */
    function execute(string $hookName, array &$args): bool
    {
        /* @var TemplateManager $templateMgr */
        $templateMgr = &$args[1];
        $output =& $args[2];
        $output .= $templateMgr->fetch($this->plugin->getTemplateResource(Constants::templateContributor));

        return Hook::CONTINUE;
    }
}
