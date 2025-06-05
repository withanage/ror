<?php
/**
 * @file RORPlugin.php
 *
 * @copyright (c) 2021+ TIB Hannover
 * @copyright (c) 2021+ Dulip Withanage
 * @copyright (c) 2021+ Gazi Yücel
 * @license Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class RorPlugin
 * @brief Ror Plugin  class
 */

namespace APP\plugins\generic\ror;

use APP\plugins\generic\ror\classes\ArticleView;
use APP\plugins\generic\ror\classes\Form;
use APP\plugins\generic\ror\classes\Schema;
use APP\plugins\generic\ror\classes\SubmissionDisplay;
use APP\plugins\generic\ror\classes\Workflow;
use PKP\plugins\GenericPlugin;
use PKP\plugins\Hook;

define('ROR_PLUGIN_NAME', basename(__FILE__, '.php'));

class RorPlugin extends GenericPlugin
{
    /** @copydoc Plugin::register */
    public function register($category, $path, $mainContextId = null): bool
    {
        if (parent::register($category, $path, $mainContextId)) {

            if ($this->getEnabled()) {
                /* ROR */
                $schema = new Schema();
                $form = new Form();
                $workflow = new Workflow($this);
                $articleView = new ArticleView($this);
                $submissionDisplay = new SubmissionDisplay($this);
                Hook::add('Schema::get::author', [$schema, 'addToAuthor']);
                Hook::add('Form::config::before', [$form, 'addFields']);
                Hook::add('Template::Workflow::Publication', [$workflow, 'execute']);
                Hook::add('Template::SubmissionWizard::Section', [$workflow, 'execute']);
                Hook::add('ArticleHandler::view', [$articleView, 'execute']);
                Hook::add('TemplateManager::display', [$submissionDisplay, 'execute']);
            }

            return true;
        }

        return false;
    }

    /** @copydoc Plugin::getDisplayName() */
    function getDisplayName(): string
    {
        return __('plugins.generic.ror.displayName');
    }

    /** @copydoc Plugin::getDescription() */
    function getDescription(): string
    {
        return __('plugins.generic.ror.description');
    }
}

// For backwards compatibility -- expect this to be removed approx. OJS/OMP/OPS 3.6
if (!PKP_STRICT_MODE) {
    class_alias('\APP\plugins\generic\ror\RorPlugin', '\RorPlugin');
}
