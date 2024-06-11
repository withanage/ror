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

class Workflow
{
    /** @var RorPlugin */
    public RorPlugin $plugin;

    /** @param RorPlugin $plugin */
    public function __construct(RorPlugin &$plugin)
    {
        $this->plugin = &$plugin;
    }

    /**
     * Lookup functionality on Contributor > Edit
     *
     * @param string $hookName
     * @param array $args [string, TemplateManager]
     * @return void
     */
    public function execute(string $hookName, array &$args): void
    {
        /* @var TemplateManager $templateMgr */
        $templateMgr = &$args[1];
        $request = Application::get()->getRequest();
        $context = $request->getContext();
        $submission = $templateMgr->getTemplateVars('submission');

        $locale = $submission->getLocale();
        if (empty($locale)) $locale = $context->getPrimaryLocale();
        if (strlen($locale) > 2) $locale = substr($locale, 0, 2);

        $templateMgr->assign([
            'stylePath' => $request->getBaseUrl() . '/' . $this->plugin->getPluginPath() . '/' . Constants::stylePath,
            'locale' => $locale
        ]);

        $templateMgr->display($this->plugin->getTemplateResource(Constants::templateContributor));
    }
}
