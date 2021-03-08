# 解决 Permission denied
# chmod +x xcodebuild.sh

# 计时
SECONDS=0

# 工程名（自定义）
project_name=Shaolin
# scheme名（自定义，一般与工程名相同）
scheme_name=Shaolin
# ipa包名（自定义，需要与导出的ipa文件名相同）
ipa_name=少林
# 打包模式 Debug/Release（自定义）
development_mode=Debug
# 发布地址 1:蒲公英, 2:TestFlight, 0:全部平台
upload_address="1"

# 蒲公英app对应的key
api_key=4485cabba956bd5d85ad1f8e800b0a3e
# 蒲公英设置安装密码
password=""
# TestFlight，苹果开发者账号和密码。
# 如果设置了双重验证，需要在https://appleid.apple.com/account/manage中的"安全"，添加"App专用密码"，使用该密码作为用户密码
dev_account=""
dev_password=""

# *** 以上信息需要手动填入 ***

# ************ 华丽的分割线 ************

# plist文件所在路径（可以先通过Xcode打一次包，就可以拿到plist文件了）
export_pgy_plist=./ExportOptions_PGY.plist
export_appStore_plist=./ExportOptions_TestFlight.plist

# 取当前时间字符串添加到文件结尾
now=$(date "+%Y-%m-%d %H-%M-%S")
# 主要用来存放生成的.xcarchive包路径
export_archivefile_path=~/Desktop/Archive/${scheme_name}/Xcarchive/${project_name}" "${now}
# 主要用来存放生成的.ipa包路径
export_pgy_ipa_path=~/Desktop/Archive/${scheme_name}/PGY/${project_name}" "${now}
export_testFlight_ipa_path=~/Desktop/Archive/${scheme_name}/TestFlight/${project_name}" "${now}
# 导出的.xcarchive包文件名
archive_path=${export_archivefile_path}/${project_name}.xcarchive
# 导出的.ipa包文件名
pgy_ipa_path="${export_pgy_ipa_path}/${ipa_name}.ipa"
testFlight_ipa_path="${export_testFlight_ipa_path}/${ipa_name}.ipa"

echo "*** 正在检查配置参数 *** "
if [ -z "${project_name}" ]; then
    echo "* project_name 不可以为空"
    exit
elif [ -z "${scheme_name}" ]; then
    echo "* scheme_name 不可以为空"
    exit
elif [ -z "${ipa_name}" ]; then
    echo "* ipa_name 不可以为空"
    exit
elif [ -z "${development_mode}" ]; then
    echo "* development_mode 不可以为空"
    exit
elif [ -z "${upload_address}" ]; then
    echo "* upload_address 不可以为空"
    exit
fi

workdir=$(cd $(dirname $0); pwd)
if [[ ${upload_address} == "1" || ${upload_address} == "0" ]];then
    if [ -z "${api_key}" ]; then
        echo "* 蒲公英 api_key 不可以为空"
        exit
    fi
    pgy_plist_path=${export_pgy_plist/./${workdir}}
    if [ ! -e "${pgy_plist_path}" ]; then
        echo "* 发布蒲公英配置文件(.plist)不存在"
        exit
    fi
fi

if [[ ${upload_address} == "2" || ${upload_address} == "0" ]];then
    if [ -z "${dev_account}" ]; then
        echo "* 开发者账号 dev_account 不可以为空"
        exit
    fi
    if [ -z "${dev_password}" ]; then
        echo "* 开发者密码 dev_password 不可以为空"
        exit
    fi

    appStore_plist_path=${export_appStore_plist/./${workdir}/}
    if [ ! -e "${appStore_plist_path}" ]; then
        echo "* 发布TestFlight配置文件(.plist)不存在"
        exit
    fi
fi
echo "*** 配置参数检查完毕 *** "

echo "*** 正在检查本地git仓库: git status -s ***"
if [ -n "$(git status -s)" ]; then
    echo "* 存在未提交代码，请提交后再运行该脚本"
    exit
fi

echo "* 获取当前分支: git symbolic-ref --short -q"
branch=$(git symbolic-ref --short -q HEAD)
if [ -n "${branch}"  ];then
  echo "* 当前分支为 ${branch}"
else
  echo "* 获取当前分支错误"
  exit
fi

echo "* 更新本地git仓库代码: git pull origin ${branch}"
git pull origin ${branch}
echo "* 检查本地git仓库: git status -s "
if [ -n "$(git status -s)" ]; then
    echo "* 存在冲突，请修改并提交后再运行该脚本 "
    exit
fi
echo "*** 本地git仓库检查完毕 ***"

# 检查各个路径是否存在，不存在则先创建对应路径
if [[ ${upload_address} == "1" || ${upload_address} == "0" ]];then
    if [ ! -d "${export_pgy_ipa_path}" ]; then
        mkdir -p "${export_pgy_ipa_path}"
    fi
fi

if [[ ${upload_address} == "2" || ${upload_address} == "0" ]];then
    if [[ ! -d "${export_testFlight_ipa_path}" ]]; then
        mkdir -p "${export_testFlight_ipa_path}"
    fi
fi

if [ ! -d "${export_archivefile_path}" ]; then
    mkdir -p "${export_archivefile_path}"
fi

# -quiet 除了错误和警告不打印任何信息
echo "*** 正在 清理工程 ***"
xcodebuild \
clean -configuration ${development_mode} -quiet || exit 
echo "*** 清理完成 ***"

echo "*** 正在 编译工程 For ${development_mode} ***"
xcodebuild \
archive -workspace ${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath "${archive_path}" \
-quiet || exit
echo "*** 编译完成 ***"

echo "*** 正在 打包 ***"
# [[]] 内部可以使用 &&，|| 进行逻辑运算；[]不可以，[]中，-a=&&，-o=||，!
if [ ${upload_address} == "1" -o ${upload_address} == "0" ];then
    xcodebuild -exportArchive -archivePath "${archive_path}" \
    -configuration ${development_mode} \
    -exportPath "${export_pgy_ipa_path}" \
    -exportOptionsPlist "${export_pgy_plist}" \
    -quiet || exit
fi
if [[ ${upload_address} == "2" || ${upload_address} == "0" ]];then
    xcodebuild -exportArchive -archivePath "${archive_path}" \
    -configuration ${development_mode} \
    -exportPath "${export_testFlight_ipa_path}" \
    -exportOptionsPlist "${export_appStore_plist}" \
    -quiet || exit
fi
echo "*** 打包 完成 ***"

# 删除build包
# if [[ -d ${export_archivefile_path} ]]; then
#    rm -rf ${export_archivefile_path} -r
# fi

if [[ ${upload_address} == "1" || ${upload_address} == "0" ]];then
    if [ -e "${pgy_ipa_path}" ]; then
        echo "*** .ipa文件已导出 ***"
		echo "*** 正在发布ipa包到 蒲公英平台 ***"
		echo "* 上传中。。。 "
    	curl -F "file=@${pgy_ipa_path}" -F "_api_key=${api_key}" -F "buildPassword=${password}" https://www.pgyer.com/apiv2/app/upload
 
    	if [ $? = 0 ];then
    		echo "*** 发布蒲公英成功 ***"
    	else
    		echo "*** 发布蒲公英失败 ***"
    	fi
    else 
        echo "*** 为蒲公英导出.ipa文件失败 ***"
    fi
fi
if [[ ${upload_address} == "2" || ${upload_address} == "0" ]]; then
    if [ -e "${testFlight_ipa_path}" ]; then
        echo "*** .ipa文件已导出 ***"
        echo "*** 验证.ipa ***"
        xcrun altool \
        --validate-app -f "${testFlight_ipa_path}" \
        -u "${dev_account}" \
        -p "${dev_password}" \
        --verbose -quiet || exit
        if [ $? = 0 ];then
            echo "*** 验证.ipa文件成功 ***"
        else
            echo "*** 验证.ipa文件失败 ***"
        fi

        echo "*** 正在发布.ipa包到 TestFlight ***"
        xcrun \
        altool --upload-app \
        -f "${testFlight_ipa_path}" \
        -u "${dev_account}" \
        -p "${dev_password}" \
        --verbose -quiet || exit

        if [ $? = 0 ];then
            echo "*** 发布TestFlight成功 ***"
        else
            echo "*** 发布TestFlight失败 ***"
        fi
    else
        echo "*** 为TestFlight导出.ipa文件失败 ***"
    fi
fi

echo "*** 发布完成 ***"

# 输出总用时
echo "执行耗时: ${SECONDS}秒"
