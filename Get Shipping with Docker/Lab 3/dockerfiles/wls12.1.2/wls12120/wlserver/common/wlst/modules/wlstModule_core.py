# Caution: This file is part of the command scripting implementation. 
# Do not edit or move this file because this may cause commands and scripts to fail. 
# Do not try to reuse the logic in this file or keep copies of this file because this 
# could cause your scripts to fail when you upgrade to a different version.
# Copyright (c) 2004,2013, Oracle and/or its affiliates. All rights reserved.

"""
This is WLST Module that a user can import into other Jython Modules in standalone 
Cam environment.

"""
from weblogic.management.scripting.core.utils import WLSTCoreUtil
import sys
origPrompt = sys.ps1
theInterpreter = WLSTCoreUtil.ensureInterpreter();
WLSTCoreUtil.ensureWLCtx(theInterpreter)
execfile(WLSTCoreUtil.getWLSTCoreScriptPath())
execfile(WLSTCoreUtil.getWLSTNMScriptPath())
execfile(WLSTCoreUtil.getOfflineWLSTScriptPath())
exec(WLSTCoreUtil.getOfflineWLSTScriptForModule())
theInterpreter = None
sys.ps1 = origPrompt
modules = WLSTCoreUtil.getWLSTModules()
for mods in modules:
  execfile(mods.getAbsolutePath())
wlstPrompt = "false"  

