# find_replace_system
 Simunlink API: find_replace_system - Searches any block/annotation/signal property in a model and replaces with the new value. 

"find_replace_system" will search and replace almost anyblock/annotation/signal property in Simulink.
Ref: Simulink API documentation "find_system".
Please refer the syntax and examples below.
Syntax:
* find_replace_system('<model name/subsystem name>',<find_system property value-pairs if required>,'<Find Property Name>','<Find Property Value>','<Replace Value>','prompt')
* find_replace_system('<model name/subsystem name>','<Find Property Name>','<Find Property Value>','<Replace Value>','prompt')
* find_replace_system('<model name/subsystem name>','<Find Property Name>','<Find Property Value>','<Replace Value>')

 find_system property value-pairs if required> Refer help find_system of all different types of properties can be used to narrow down the search, 'LookUnderMasks', 'RegExp', 'SearchDepth', 'FollowLinks', etc..

 prompt' is an optional keyword.

Example:
* find_replace_system('sldemo_autotrans','LookUnderMasks','all','FindAll','on','type','block','Name','Transmission','AutoTransmission','prompt')
* find_replace_system('sldemo_autotrans','ForegroundColor','Red','Blue')
* find_replace_system('sldemo_clutch/Friction Mode Logic','Position',get_param('sldemo_clutch/Friction Mode Logic','Position'),[250 292 400 433],'prompt')
* find_replace_system(gcs,'SampleTime','-1','0.1','prompt')
* find_replace_system(gcs,'Amplitude','3','1.5')
* find_replace_system(gcs,'ZeroCross','on','off','prompt')
 

MATLAB Release Compatibility: Created with R2010b, Compatible with any release
 
Please share your comments and suggestions.
 
Developed by: Sysenso Systems, www.sysenso.com
  
If you are interested to have GUI based Find and Replace Tool which has more features, please write to us contactus@sysenso.com
 
