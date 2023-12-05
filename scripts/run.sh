#!/bin/bash
set -e
MilvusUserConfigMountPath="/milvus/configs/user.yaml"
MilvusOriginalConfigPath="/milvus/configs/milvus.yaml"
MilvusHookConfigMountPath="/milvus/configs/hook.yaml"
MilvusHookConfigUpdatesMountPath="/milvus/configs/hook_updates.yaml"
# merge config
/milvus/tools/merge -s ${MilvusUserConfigMountPath} -d ${MilvusOriginalConfigPath}
/milvus/tools/merge -s ${MilvusHookConfigUpdatesMountPath} -d ${MilvusHookConfigMountPath}
# ajust oom_adj if env OOM_ADJ is set
if [ -n "$OOM_ADJ" ]; then
    echo "oom_adj is set to $OOM_ADJ"
    echo "$OOM_ADJ" > /proc/$$/oom_adj
fi
# ajust oom_score_adj if env OOM_SCORE_ADJ is set
if [ -n "$OOM_SCORE_ADJ" ]; then
    echo "oom_score_adj is set to $OOM_SCORE_ADJ"
    echo "$OOM_SCORE_ADJ" > /proc/$$/oom_score_adj
fi
# run commands
exec $@
