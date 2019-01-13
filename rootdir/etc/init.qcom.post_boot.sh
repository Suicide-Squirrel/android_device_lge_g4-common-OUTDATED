#!/system/bin/sh
# Copyright (c) 2012-2017, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Create cpu device needed to keep only realtime tasks
touch /dev/cpuctl/tasks
chmod 777 /dev/cpuctl/tasks
mkdir /data/misc/perfd
chmod 777 /data/misc/perfd

# Create file for ipconfig
touch /data/misc/ethernet/ipconfig.txt
chmod 755 /data/misc/ethernet/ipconfig.txt

# We chown/chmod /persist again so because mount is run as root + defaults
chown system system /persist
chmod 771 /persist
chmod 666 /sys/devices/platform/msm_sdcc.1/polling
chmod 666 /sys/devices/platform/msm_sdcc.2/polling
chmod 666 /sys/devices/platform/msm_sdcc.3/polling
chmod 666 /sys/devices/platform/msm_sdcc.4/polling

# Chown polling nodes as needed from UI running on system server
chown system system /sys/devices/platform/msm_sdcc.1/polling
chown system system /sys/devices/platform/msm_sdcc.2/polling
chown system system /sys/devices/platform/msm_sdcc.3/polling
chown system system /sys/devices/platform/msm_sdcc.4/polling

# Create the symlink to qcn wpa_supplicant folder for ar6000 wpa_supplicant
mkdir /data/system 775 system system

# Create directories for Location services
mkdir /data/misc/location 775 gps gps
mkdir /data/misc/location/mq 775 gps gps
mkdir /data/misc/location/xtwifi 775 gps gps
mkdir /data/misc/location/gpsone_d 775 system gps
mkdir /data/misc/location/quipc 775 gps system
mkdir /data/misc/location/gsiff 775 gps gps

# Create directory from IMS services
mkdir /data/shared 755
chown system system /data/shared

# Create directory for FOTA
mkdir /data/fota 771
chown system system /data/fota

# Make sure the default firmware is loaded
echo "/system/etc/firmware/fw_bcmdhd.bin" > /sys/module/bcmdhd/parameters/firmware_path

# Create directory for hostapd
mkdir /data/hostapd 775 system wifi

# Provide the access to hostapd.conf only to root and group
chmod 660 /data/hostapd/hostapd.conf

# Create /data/time folder for time-services
mkdir /data/time/ 744 system system

mkdir /data/audio/ 775 media audio

# Create a folder for audio delta files
mkdir /data/audio/acdbdata 775 media audio
mkdir /data/audio/acdbdata/delta 775 media audio

setprop vold.post_fs_data_done 1

# Create a folder for SRS to be able to create a usercfg file
mkdir /data/data/media 775 media media

# Create PERFD deamon related dirs
mkdir /data/misc/perfd 755 root system
chmod 2755 /data/misc/perfd
mkdir /data/system/perfd 775 root system
chmod 2775 /data/system/perfd
rm /data/system/perfd/default_values

# Create directory used by sensor subsystem
mkdir /persist/sensors 775 system root
chmod 666 /persist/sensors/sensors_settings
chown system root /persist/sensors/sensors_settings
mkdir /data/misc/sensors 775 system system
restorecon_recursive /data/misc/sensors

mkdir /data/tombstones 771 system system
mkdir /tombstones/modem 771 system system
mkdir /tombstones/lpass 771 system system
mkdir /tombstones/wcnss 771 system system
mkdir /tombstones/dsps 771 system system
mkdir /persist/data/sfs 744 system system
mkdir /persist/data/tz 744 system system
mkdir /persist/tee 744 system system
mkdir /data/app/mcRegistry 775 system system
ln -s /persist/tee/00000000.authtokcont.backup /data/app/mcRegistry/00000000.authtokcont.backup
chown root cw_access /cota
chmod 771 /cota
chown system system /preload
chmod 771 /preload

# set device node permissions for TLC apps
chmod 644 /dev/mobicore
chown system system /dev/mobicore
chmod 666 /dev/mobicore-user
chown system system /dev/mobicore-user

# restorecon cota partition.
restorecon_recursive /cota

mkdir /data/usf 744 system system

# Z2G4-BSP-TS@lge.com make directory for sns.reg used by sensordaemon
mkdir /sns/cal/ 644 system system
restorecon_recursive /sns

# PCC Calibration
chown system system /sys/devices/virtual/graphics/fb0/rgb
chmod 660 /sys/devices/virtual/graphics/fb0/rgb

# LGE_CHANGE_S, [LGE_DATA][LGP_DATA_TCPIP_NSRM]
targetProd=`getprop ro.product.name`
case "$targetProd" in
    "z2_lgu_kr" | "p1_lgu_kr" | "z2_skt_kr" | "p1_skt_kr" | "p1_kt_kr" | "p1_bell_ca" | "p1_rgs_ca" | "p1_tls_ca")
    mkdir /data/connectivity/
    chown system.system /data/connectivity/
    chmod 775 /data/connectivity/
    mkdir /data/connectivity/nsrm/
    chown system.system /data/connectivity/nsrm/
    chmod 775 /data/connectivity/nsrm/
    cp /system/etc/dpm/nsrm/NsrmConfiguration.xml /data/connectivity/nsrm/
    chown system.system /data/connectivity/nsrm/NsrmConfiguration.xml
    chmod 775 /data/connectivity/nsrm/NsrmConfiguration.xml
    ;;
esac
# LGE_CHANGE_E, [LGE_DATA][LGP_DATA_TCPIP_NSRM]

target=`getprop ro.board.platform`
case "$target" in
    "msm8992")
        # disable thermal bcl hotplug to switch governor
        echo 0 > /sys/module/msm_thermal/core_control/enabled
        for mode in /sys/devices/soc.0/qcom,bcl.*/mode
        do
            echo -n disable > $mode
        done
        for hotplug_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_mask
        do
            bcl_hotplug_mask=`cat $hotplug_mask`
            echo 0 > $hotplug_mask
        done
        for hotplug_soc_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask
        do
            bcl_soc_hotplug_mask=`cat $hotplug_soc_mask`
            echo 0 > $hotplug_soc_mask
        done
        for mode in /sys/devices/soc.0/qcom,bcl.*/mode
        do
            echo -n enable > $mode
        done

        # ensure at most one A57 is online when thermal hotplug is disabled
        echo 0 > /sys/devices/system/cpu/cpu5/online
        # online CPU4
        echo 1 > /sys/devices/system/cpu/cpu4/online
        echo conservative > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
        # configure CPU0
        echo blu_active > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
        echo 960000 > /sys/devices/system/cpu/cpu0/cpufreq/blu_active/hispeed_freq
        # restore A57's max
        cat /sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_max_freq > /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq
        # plugin remaining A57s
        echo 1 > /sys/devices/system/cpu/cpu5/online
        # Restore CPU 4 max freq from msm_performance
        echo "4:1632000 5:1632000" > /sys/module/msm_performance/parameters/cpu_max_freq
	# input boost,cpu boost
	echo 0:672000 1:0 2:0 3:0 4:480000 5:0 > /sys/module/cpu_boost/parameters/input_boost_freq
        # multi boost configuration
        echo 0:672000 > /sys/module/cpu_boost/parameters/multi_boost_freq

        # Setting b.L scheduler parameters
        echo 1 > /proc/sys/kernel/sched_migration_fixup
        echo 30 > /proc/sys/kernel/sched_small_task
        echo 20 > /proc/sys/kernel/sched_mostly_idle_load
        echo 3 > /proc/sys/kernel/sched_mostly_idle_nr_run
        echo 99 > /proc/sys/kernel/sched_upmigrate
        echo 85 > /proc/sys/kernel/sched_downmigrate
        echo 400000 > /proc/sys/kernel/sched_freq_inc_notify
        echo 400000 > /proc/sys/kernel/sched_freq_dec_notify
        echo 70 > /proc/sys/vm/dirty_background_ratio
        echo 1000 > /proc/sys/vm/dirty_expire_centisecs
        echo 100 > /proc/sys/vm/swappiness
        #enable rps static configuration
        echo 8 >  /sys/class/net/rmnet_ipa0/queues/rx-0/rps_cpus
        for devfreq_gov in /sys/class/devfreq/qcom,cpubw*/governor
        do
            echo "bw_hwmon" > $devfreq_gov
        done
		for devfreq_gov in /sys/class/devfreq/qcom,mincpubw*/governor
        do
            echo "cpufreq" > $devfreq_gov
        done

        # Disable sched_boost
        # echo 0 > /proc/sys/kernel/sched_boost

		# Set Memory parameters
        configure_memory_parameters
        restorecon -R /sys/devices/system/cpu

	    # Disable CPU retention
	    echo 0 > /sys/module/lpm_levels/system/a53/cpu0/retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a53/cpu1/retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a53/cpu2/retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a53/cpu3/retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a57/cpu4/retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a57/cpu5/retention/idle_enabled

	    # Disable L2 retention
	    echo 0 > /sys/module/lpm_levels/system/a53/a53-l2-retention/idle_enabled
	    echo 0 > /sys/module/lpm_levels/system/a57/a57-l2-retention/idle_enabled

	    # Disable CPU Standalone Power Collapse
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu0/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu1/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu2/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu3/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a57/cpu4/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a57/cpu5/standalone_pc/idle_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu0/standalone_pc/suspend_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu1/standalone_pc/suspend_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu2/standalone_pc/suspend_enabled
	    echo "N" > /sys/module/lpm_levels/system/a53/cpu3/standalone_pc/suspend_enabled
	    echo "N" > /sys/module/lpm_levels/system/a57/cpu4/standalone_pc/suspend_enabled
	    echo "N" > /sys/module/lpm_levels/system/a57/cpu5/standalone_pc/suspend_enabled

        # re-enable thermal and BCL hotplug
        echo 1 > /sys/module/msm_thermal/core_control/enabled
        for mode in /sys/devices/soc.0/qcom,bcl.*/mode
        do
            echo -n disable > $mode
        done
        for hotplug_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_mask
        do
            echo $bcl_hotplug_mask > $hotplug_mask
        done
        for hotplug_soc_mask in /sys/devices/soc.0/qcom,bcl.*/hotplug_soc_mask
        do
            echo $bcl_soc_hotplug_mask > $hotplug_soc_mask
        done
        for mode in /sys/devices/soc.0/qcom,bcl.*/mode
        do
            echo -n enable > $mode
        done

        # enable low power mode sleep
        echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
    ;;
esac

# Post-setup services
case "$target" in
    "msm8660" | "msm8960" | "msm8226" | "msm8610" | "mpq8092" )
        start mpdecision
    ;;
    "msm8916")
        if [ -f /sys/devices/soc0/soc_id ]; then
           soc_id=`cat /sys/devices/soc0/soc_id`
        else
           soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi
        if [ $soc_id = 239 ]; then
            setprop ro.min_freq_0 800000
            setprop ro.min_freq_4 499200
        else
            setprop ro.min_freq_0 800000
        fi
        #start perfd after setprop
        start perfd # start perfd on 8916 and 8939
    ;;
    "msm8974")
        start mpdecision
        echo 512 > /sys/block/mmcblk0/bdi/read_ahead_kb
    ;;
    "msm8994" | "msm8992")
        rm /data/system/perfd/default_values
        setprop ro.min_freq_0 384000
        setprop ro.min_freq_4 384000
        start perfd
    ;;
    "apq8084")
        rm /data/system/perfd/default_values
        start mpdecision
        echo 512 > /sys/block/mmcblk0/bdi/read_ahead_kb
        echo 512 > /sys/block/sda/bdi/read_ahead_kb
        echo 512 > /sys/block/sdb/bdi/read_ahead_kb
        echo 512 > /sys/block/sdc/bdi/read_ahead_kb
        echo 512 > /sys/block/sdd/bdi/read_ahead_kb
        echo 512 > /sys/block/sde/bdi/read_ahead_kb
        echo 512 > /sys/block/sdf/bdi/read_ahead_kb
        echo 512 > /sys/block/sdg/bdi/read_ahead_kb
        echo 512 > /sys/block/sdh/bdi/read_ahead_kb
    ;;
    "msm7627a")
        if [ -f /sys/devices/soc0/soc_id ]; then
            soc_id=`cat /sys/devices/soc0/soc_id`
        else
            soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi
        case "$soc_id" in
            "127" | "128" | "129")
                start mpdecision
        ;;
        esac
    ;;
esac

case "$target" in
    "msm8226" | "msm8974" | "msm8610" | "apq8084" | "mpq8092" | "msm8610" | "msm8916" | "msm8994" | "msm8992")
        # Let kernel know our image version/variant/crm_version
        image_version="10:"
        image_version+=`getprop ro.build.id`
        image_version+=":"
        image_version+=`getprop ro.build.version.incremental`
        image_variant=`getprop ro.product.name`
        image_variant+="-"
        image_variant+=`getprop ro.build.type`
        oem_version=`getprop ro.build.version.codename`
        echo 10 > /sys/devices/soc0/select_image
        echo $image_version > /sys/devices/soc0/image_version
        echo $image_variant > /sys/devices/soc0/image_variant
        echo $oem_version > /sys/devices/soc0/image_crm_version
        ;;
esac

# Enable QDSS agent if QDSS feature is enabled
# on a non-commercial build.  This allows QDSS
# debug tracing.
if [ -c /dev/coresight-stm ]; then
    build_variant=`getprop ro.build.type`
    if [ "$build_variant" != "user" ]; then
        # Test: Is agent present?
        if [ -f /data/qdss/qdss.agent.sh ]; then
            # Then tell agent we just booted
           /system/bin/sh /data/qdss/qdss.agent.sh on.boot &
        fi
    fi
fi
