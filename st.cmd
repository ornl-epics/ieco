#!../../bin/linux-x86_64/IECO

## You may have to change IECO to something else
## everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/IECO.dbd"
IECO_registerRecordDeviceDriver pdbbase

epicsEnvSet("STREAM_PROTOCOL_PATH", "$(ICP)/protocol/")

#IECO PS
drvAsynIPPortConfigure ("ICP1","10.112.131.120:4001",0,0,0)



## Load record instances
dbLoadRecords("db/IECOICP.db")

#########################################
#AUTOSAVE
epicsEnvSet("IOCNAME","bl4a-SE-IECO")
epicsEnvSet("SAVE_DIR","/home/controls/var/$(IOCNAME)")

save_restoreSet_Debug(0)

### status-PV prefix, so save_restore can find its status PV's.
save_restoreSet_status_prefix("BL4A:SE:IECO")

set_requestfile_path("$(SAVE_DIR)")
set_savefile_path("$(SAVE_DIR)")

save_restoreSet_NumSeqFiles(3)
save_restoreSet_SeqPeriodInSeconds(600)
set_pass0_restoreFile("$(IOCNAME).sav")
########################################

cd "${TOP}/iocBoot/${IOC}"
iocInit


epicsThreadSleep(5)
makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOCNAME).req", "autosaveFields")
create_monitor_set("$(IOCNAME).req", 5)
