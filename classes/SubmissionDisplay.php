<?php

/**
 * @file classes/SubmissionDisplay.php
 *
 * @copyright (c) 2021+ TIB Hannover
 * @copyright (c) 2021+ Gazi Yücel
 * @copyright (c) 2025+ Lepidus Tecnologia
 * @license Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class SubmissionDisplay
 * @brief Submission Display
 */

namespace APP\plugins\generic\ror\classes;

use APP\core\Application;
use APP\plugins\generic\ror\RorPlugin;
use APP\template\TemplateManager;
use Exception;
use PKP\core\Core;

class SubmissionDisplay
{
    /** @var RorPlugin */
    private RorPlugin $plugin;

    /** @param RorPlugin $plugin */
    public function __construct(RorPlugin &$plugin)
    {
        $this->plugin = &$plugin;
    }

    /**
     * Add Ror ID on front page of submission.
     *
     * @param string $hookName
     * @param array $args
     * @return bool
     * @throws Exception
     */
    function execute(string $hookName, array $args): bool
    {
        $templateMgr = &$args[0];
        $template = $args[1];
        $output =& $args[2];

        $applicationName = Application::getApplication()->getName();

        if ($applicationName === 'ojs2') return false;

        if (!in_array($template, ['frontend/pages/book.tpl', 'frontend/pages/preprint.tpl'])) {
            return false;
        }

        $icon = '';
        $iconPath = Core::getBaseDir() . '/' . $this->plugin->getPluginPath() . '/' . Constants::iconPath;

        if (file_exists($iconPath)) $icon = file_get_contents($iconPath);

        $templateMgr->assign([Constants::iconNameInTemplate => $icon]);

        $activeTheme = $templateMgr->getTemplateVars('activeTheme');
        if ($activeTheme->getDirName() === 'default') {
            $templateMgr->registerFilter("output", array($this, 'submissionDisplayFilter'));
        }

        return false;
    }

    /**
     * Filter to include Ror ID submission template.
     *
     * @param string $output
     * @param TemplateManager $templateMgr
     * @return string
     */
    function submissionDisplayFilter($output, $templateMgr) {
        $applicationName = Application::get()->getName();
        $authorsPattern = $applicationName === 'ops'
            ? '/<section class="item authors">([\s\S]*?)<\/section>/'
            : '/<div class="item authors">([\s\S]*?)<\/div>\s*(?=\s*<div class="item)/';
        if (preg_match($authorsPattern, $output, $matches, PREG_OFFSET_CAPTURE)) {
            $match = $matches[1][0];
            $offset = $matches[1][1];
            $newOutput = substr($output, 0, $offset);
            $newOutput .= $templateMgr->fetch($this->plugin->getTemplateResource($applicationName . '_authors.tpl'));
            $newOutput .= substr($output, $offset + strlen($match));
            $output = $newOutput;
            $templateMgr->unregisterFilter('output', array($this, 'submissionDisplayFilter'));
        }
        return $output;
    }
}
