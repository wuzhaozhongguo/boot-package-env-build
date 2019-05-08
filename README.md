# 构建环境镜像->运行打包
#### 1.执行权限
<pre>
    <code>
        chmod +x build/build-entrypoint.sh
    </code>
</pre>
#### 2.构建
<pre>
    <code>
        docker build -t="xxxx/boot-package" .
    </code>
</pre>
#### 3.运行打包

# shell
#### build-env.sh
构建打包环境镜像
#### run-package.sh
运行打包

<pre>
    <code>
        docker run --rm \
        -e TOKEN_GIT_URL="${giturl}" \
        -e BUILD_ID="dev-boot-demo" \
        --name=boot-package-run-temp \
        -v maven-repo:/root/.m2/repository -v /var/lib/boot-build/:/app/package \
        domain/namespace/boot-package
    </code>
</pre>
参数:
TOKEN_GIT_URL是仓库url,可以是公开的仓库，或者使用token访问，如果用ssh方式需要将密钥打包进镜像不安全
BUILD_ID 是构建id，具有唯一性，类似jenkins的JOB_NAME，在/var/lib/boot-build/${BUILD_ID}/目录下生成app.jar，相同名称会被覆盖
卷:
maven-repo卷缓存构建的jar，/var/lib/boot-build/${BUILD_ID}/目录共享打包后的jar文件
其他说明:
build文件夹中的settings.xml可以替换成自己的文件，但是镜像不要推送到公共仓库去