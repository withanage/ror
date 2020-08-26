<?php
/**
 * @file RORPlugin.php
 *
 * Copyright (c) 2015-2019 University of Pittsburgh
 * Copyright (c) 2014-2020 Simon Fraser University
 * Copyright (c) 2003-2020 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 * @class RorPlugin
 *
 * @brief Ror Plugin  class
 */
import('lib.pkp.classes.plugins.GenericPlugin');

/**
 * Class rorPlugin
 */
class RORPlugin extends GenericPlugin
{

	/**
	 * @copydoc Plugin::register()
	 */
	public function register($category, $path, $mainContextId = NULL) {

		$success = parent::register($category, $path, $mainContextId);

		if ($success && $this->getEnabled()) {
			HookRegistry::register('authorform::display', array($this, 'handleAutorFormDisplay'));
		}
		return $success;
	}

	function handleAutorFormDisplay($hook, $args) {
		$request = PKPApplication::get()->getRequest();
		$templateMgr = TemplateManager::getManager($request);
		$templateMgr->registerFilter("output", array($this, 'authorFormFilter'));
		return false;
	}

	function authorFormFilter($output, $templateMgr) {
		if (preg_match('/<input[^>]+name="submissionId"[^>]*>/', $output, $matches, PREG_OFFSET_CAPTURE)) {
			$match = $matches[0][0];
			$offset = $matches[0][1];
			$newOutput = substr($output, 0, $offset + strlen($match));
			$newOutput .= $templateMgr->fetch($this->getTemplateResource('affiliation.tpl'));
			$newOutput .= substr($output, $offset + strlen($match));
			$output = $newOutput;
			$templateMgr->unregisterFilter('output', array($this, 'authorFormFilter'));
		}
		return $output;
	}


	/**
	 * @copydoc Plugin::getDisplayName()
	 */
	function getDisplayName() {
		return __('plugins.generic.ror.displayName');
	}

	/**
	 * @copydoc Plugin::getDescription()
	 */
	function getDescription() {
		return __('plugins.generic.ror.description');
	}

}
