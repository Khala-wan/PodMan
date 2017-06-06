#!/bin/sh

#$1:pod地址
#$2:name
#$3:swift/OC
#$4:demo?
#$5:test?
#$6:viewTest?

export LANG=en_US.UTF-8

cd $1
rm -rf $2
/usr/bin/git clone git@github.com:Khala-wan/pod-template.git
mv ./pod-template ./$2
cd $2
if [ $3 == "swift" ]
then
    echo "创建Swift Pod"
    sed -i '' 's/self.ask_with_answers(\"What language do you want to use?\", \[\"Swift\", \"ObjC\"\]).to_sym/\"swift\".to_sym/' ./setup/TemplateConfigurator.rb
else
    echo "创建Objective-C Pod"
    sed -i '' 's/self.ask_with_answers(\"What language do you want to use?\", \[\"Swift\", \"ObjC\"\]).to_sym/\"objc\".to_sym/' ./setup/TemplateConfigurator.rb
fi

if [ $4 == "yes" ]
then
    echo "创建Demo"
    sed -i '' 's/configurator.ask_with_answers(\"Would you like to include a demo application with your library\", \[\"Yes\", \"No\"\]).to_sym/\"yes\".to_sym/' ./setup/ConfigureSwift.rb
    sed -i '' 's/configurator.ask_with_answers(\"Would you like to include a demo application with your library\", \[\"Yes\", \"No\"\]).to_sym/\"yes\".to_sym/' ./setup/ConfigureiOS.rb
else
    echo "不创建Demo"
sed -i '' 's/configurator.ask_with_answers(\"Would you like to include a demo application with your library\", \[\"Yes\", \"No\"\]).to_sym/\"no\".to_sym/' ./setup/ConfigureSwift.rb
sed -i '' 's/configurator.ask_with_answers(\"Would you like to include a demo application with your library\", \[\"Yes\", \"No\"\]).to_sym/\"no\".to_sym/' ./setup/ConfigureiOS.rb
fi

if [[ $5 == "Quick" || $5 == "Specta" ]]
then
    echo "Swift Use Quick"
    sed -i '' 's/configurator.ask_with_answers(\"Which testing frameworks will you use\", \[\"Quick\", \"None\"\]).to_sym/\"quick\".to_sym/' ./setup/ConfigureSwift.rb

    echo "OC Use Specta"
    sed -i '' 's/configurator.ask_with_answers(\"Which testing frameworks will you use\", \[\"Specta\", \"Kiwi\", \"None\"\]).to_sym/\"specta\".to_sym/' ./setup/ConfigureiOS.rb
elif [ $5 == "Kiwi" ]
then
    echo "OC Use Kiwi"
    sed -i '' 's/configurator.ask_with_answers(\"Which testing frameworks will you use\", \[\"Specta\", \"Kiwi\", \"None\"\]).to_sym/\"kiwi\".to_sym/' ./setup/ConfigureiOS.rb
else
    echo "Swift Use None"
    sed -i '' 's/configurator.ask_with_answers(\"Which testing frameworks will you use\", \[\"Quick\", \"None\"\]).to_sym/\"none\".to_sym/' ./setup/ConfigureSwift.rb

    echo "OC Use None"
    sed -i '' 's/configurator.ask_with_answers(\"Which testing frameworks will you use\", \[\"Specta\", \"Kiwi\", \"None\"\]).to_sym/\"none\".to_sym/' ./setup/ConfigureiOS.rb
fi

if [ $6 == "yes" ]
then
    echo "Swift View test"
    sed -i '' 's/configurator.ask_with_answers(\"Would you like to do view based testing\", \[\"Yes\", \"No\"\]).to_sym/\"yes\".to_sym/' ./setup/ConfigureSwift.rb
    echo "OC View test"
    sed -i '' 's/configurator.ask_with_answers(\"Would you like to do view based testing\", \[\"Yes\", \"No\"\]).to_sym/\"yes\".to_sym/' ./setup/ConfigureiOS.rb

else
    echo "Swift No View test"
    sed -i '' 's/configurator.ask_with_answers(\"Would you like to do view based testing\", \[\"Yes\", \"No\"\]).to_sym/\"no\".to_sym/' ./setup/ConfigureSwift.rb
    echo "OC No View test"
    sed -i '' 's/configurator.ask_with_answers(\"Would you like to do view based testing\", \[\"Yes\", \"No\"\]).to_sym/\"no\".to_sym/' ./setup/ConfigureiOS.rb
fi
sed -i '' 's/configurator.ask(\"What is your class prefix\")/\"PM\"/' ./setup/ConfigureiOS.rb

./configure $2
#还没搞清为什么ruby脚本的sytem(pod install)不成功，所以只好自己跑一遍pod install了
cd Example
/usr/local/bin/pod install
open $2".xcworkspace"

if [ $? -eq 0 ]
then
    echo "PodProcessSuccessed"
else
    echo "PodProcessFailed"
fi

