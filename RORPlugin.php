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
class RORPlugin extends GenericPlugin {

	/**
	 * @copydoc Plugin::register()
	 */
	public function register($category, $path, $mainContextId = NULL) {

		$success = parent::register($category, $path, $mainContextId);

		if ($success && $this->getEnabled()) {
			# Author form
			HookRegistry::register('authordao::getAdditionalFieldNames', array($this, 'handleAdditionalFieldNames'));
			HookRegistry::register('authorform::display', array($this, 'handleFormDisplay'));
			HookRegistry::register('authorform::execute', array($this, 'handleAuthorFormExecute'));
			HookRegistry::register('Schema::get::author', function ($hookName, $args) {
				$schema = $args[0];

				$schema->properties->rorId = (object)[
					'type' => 'string',
					'apiSummary' => true,
					'validation' => ['nullable']
				];
			});
			# Submission
			HookRegistry::register('ArticleHandler::view', array(&$this, 'submissionView'));
			HookRegistry::register('PreprintHandler::view', array(&$this, 'submissionView'));

		}
		return $success;
	}

	function addSubmissionDisplay($hookName, $params) {
		$templateMgr = $params[1];
		$output =& $params[2];

		$submission = $templateMgr->get_template_vars('monograph') ? $templateMgr->get_template_vars('monograph') : $templateMgr->get_template_vars('article');

	}

	function handleAuthorFormExecute($hookname, $args) {
		$form =& $args[0];
		$form->readUserVars(array('affiliation'));
		$author = $form->getAuthor();
		$affiliation = $form->getData('affiliation');

		$publicationLocale = $form->getDefaultFormLocale();
		$rorIDPattern = '/\[[\s]*https:\/\/ror\.org\/[\w|\d]*[\s]*\]/';

		foreach ($affiliation as $locale => $value) {

			preg_match($rorIDPattern, $value, $matches);
			if (count($matches) > 0) {
				$author->setData('rorId', str_replace(['[', ']'], '', $matches[0]));
				$affiliation = preg_replace($rorIDPattern, '', $value);
				$author->setData('affiliation', $affiliation, $locale);
			} else {
				if ($locale == $publicationLocale) {
					$currentAffiliation = $author->getData('affiliation', $locale);
					if ($currentAffiliation !== $value) {
						$author->setData('rorId', null);
					}
				}
			}
		}
	}

	function handleFormDisplay($hookName, $args) {
		$request = PKPApplication::get()->getRequest();
		$templateMgr = TemplateManager::getManager($request);

		switch ($hookName) {
			case 'authorform::display':
				$authorForm =& $args[0];
				$author = $authorForm->getAuthor();
				if ($author) {
					$templateMgr->assign(
						array(
							'rorId' => $author->getData('rorId'),
							'rorPlaceHolder' => __('plugins.generic.ror.rorPlaceHolder'),
							'rorSupportedLocales'  => $request->getJournal()->getSupportedLocaleNames()
						)
					);
				}
				$templateMgr->registerFilter("output", array($this, 'authorFormFilter'));
				break;
		}
		return false;
	}

	function submissionView($hook, $args) {
		$request = $args[0];
		$templateMgr = TemplateManager::getManager($request);
		$templateMgr->assign(array(
			"rorIdIcon" => $this->getIcon()
		));
		return false;
	}

	function getIcon() {
		$pluginPath = $this->getPluginPath();
		$path = Core::getBaseDir() . '/' . $pluginPath . '/assets/rorId.svg';
		return file_exists($path) ? file_get_contents($path) : '';
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

	function handleAdditionalFieldNames($hookName, $params) {
		$fields =& $params[1];
		$fields[] = 'rorId';
		return false;
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
