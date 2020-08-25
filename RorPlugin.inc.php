<?php
import('lib.pkp.classes.plugins.GenericPlugin');

/**
 * Class rorPlugin
 */
class RorPlugin extends GenericPlugin
{

	/**
	 * @copydoc Plugin::register()
	 */
	public function register($category, $path, $mainContextId = NULL) {

		$success = parent::register($category, $path, $mainContextId);

		if ($success && $this->getEnabled()) {

			//HookRegistry::register('authorform::display', array($this, 'handleAutorFormDisplay'));

		}
		return $success;
	}

	function handleAutorFormDisplay($hook, $args) {
		$request = PKPApplication::get()->getRequest();
		$templateMgr = TemplateManager::getManager($request);
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
