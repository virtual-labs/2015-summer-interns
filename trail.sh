#nitializing variables
bit=32
bitv="x86_64"
source=".rpm"
model="Ubuntu"
extra="jre"

#setting proxy
export http_proxy="proxy.iiit.ac.in:8080"
export https_proxy="proxy.iiit.ac.in:8080"

#checking for system version
uname -m > vers.txt
while read -r li; do
if [ $bitv = $li ]
then
bit=64
break;
else
break;
fi
done < vers.txt

#checking if it is ubuntu/centos,updating,wget initalizing
cat /etc/issue > vers.txt
while read -r li; do
if echo "$li" | grep -q "$model";then
echo "Updating this Ubuntu Machine";
 apt-get update
 apt-get install wget
break;
else
echo "Updating this CentOs Machine";
model="Centos"
 yum update
 yum install wget
break;
fi
done < vers.txt

#reading given text file for just length
lineno=0
while read -r line; do
lineno=`expr $lineno + 1`
done < basic.txt

#reading given text file with nth line
i=0

while [ $i -lt $lineno ]; do                                       #WHILE_LOOP_START  $$$$$
i=`expr $i + 1`
head -$i basic.txt | tail -1 > vers.txt
read -r line < vers.txt

#checking if another version of java is previously installed?
java -version
java_result=`echo $?`

line="$line-linux"

if test $bit -eq 32
then
line="$line-x86"
else
line="$line-x64"
fi

if [ $model = "Ubuntu" ]
then
lback=$line
line="$line-u"
else
lback=$line
line="$line-c"
fi

#Downloading and
#Installing
if [ $model = "Ubuntu" ]
then
#Setting Proxy 
export http_proxy=""
wget -r --no-parent 10.4.15.172/$line/
cd 10.4.15.172/$line/
apt-get install *.deb
success=`echo $?`
cd -
else
#Setting Proxy
export http_proxy=""
wget -r --no-parent 10.4.15.172/$line/
yum install *.rpm
success=`echo $?`
cd -
fi

if test $success -eq 0                                      #IF_LOOP_START      %%%%%
then

if echo "$line" | grep -q "$extra";then                     #IF_LOOP_START      @@@@@

if test $java_result -eq 0                                  #IF_LOOP_START      *****
then
#Asking User to select Required Java Version
echo " Please select $lback version "
if [ $model = "Centos" ];then alternatives --config java;else echo "";fi
fi                                                          #IF_LOOP_END        *****

if [ $model = "Centos" ]                                    #IF_LOOP_START      =====
then
echo ""
##---------FOR_CENTOS-----------
#now to set path...
#if echo "$line" | grep -q "$extra";then
#echo "JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.79.x86_64" >> "/etc/profile"
#echo "PATH=$PATH:$HOME/bin:$JAVA_HOME/bin" >> "/etc/profile"
#echo "export JAVA_HOME" >> "/etc/profile" 
#echo "export JRE_HOME" >> "/etc/profile"
#echo "export PATH" >> "/etc/profile"
#fi
#-------------------------------- 
else
echo ""
##--------FOR_UBUNTU-------------
#now to set path...
#if echo "$line" | grep -q "$extra";then
#echo "JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64" >> "/etc/profile"
#echo "PATH=$PATH:$HOME/bin:$JAVA_HOME/bin" >> "/etc/profile"
#echo "export JAVA_HOME" >> "/etc/profile" 
#echo "export JRE_HOME" >> "/etc/profile"
#echo "export PATH" >> "/etc/profile"
#fi
#--------------------------------
fi                                                          #IF_LOOP_END       =====

fi                                                          #IF_LOOP_END       @@@@@

else
echo "INSTALLING DEPENDENCIES"

if [ $model = "Ubuntu" ]                                    #IF_LOOP_START     +++++
then
export http_proxy="http://proxy.iiit.ac.in:8080"
 apt-get -f install
else
export http_proxy="http://proxy.iiit.ac.in:8080"
sudo yum update
#sudo yum localinstall $line
fi                                                          #IF_LOOP_END       +++++
echo "INSTALLED DEPENDENCIES"

fi                                                          #IF_LOOP_END       %%%%%


done                                                        #WHILE_LOOP_END    $$$$$  

#having old proxy
export http_proxy="http://proxy.iiit.ac.in:8080"

pwd > vers.txt
read -r li < vers.txt
rm $li/vers.txt
#rm -R $line