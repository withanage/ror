<?php
import('lib.pkp.classes.plugins.GenericPlugin');

/**
 * Class rorPlugin
 */
class RorPlugin extends GenericPlugin {
	public function register($category, $path, $mainContextId = NULL) {

		// Register the plugin even when it is not enabled
		$success = parent::register($category, $path);

		if ($success && $this->getEnabled()) {
			// Do something when the plugin is enabled
		}

		return $success;
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
