#!/bin/sh

#$1:pod地址
#$2:name
#$3:swift/OC
#$4:demo?
#$5:test?
#$6:viewTest?

export LANG=en_US.UTF-8
#echo 沙盒地址
#read sandBoxPath

#cd $1
#echo $1
#rm -rf $2
/usr/bin/git clone git@github.com:Khala-wan/pod-template.git
#mv ./pod-template ./$2
#cd $2

#if [ $3 == "YES" ]
#then
#    echo "创建Swift Pod"
#    sed -i '' 's/self.ask_with_answers(\"What language do you want to use?\", \[\"Swift\", \"ObjC\"\]).to_sym/swift/' ./setup/TemplateConfigurator.rb
#else
#    echo "创建Objective-C Pod"
#    sed -i '' 's/self.ask_with_answers(\"What language do you want to use?\", \[\"Swift\", \"ObjC\"\]).to_sym/objc/' ./setup/TemplateConfigurator.rb
#fi
#
#if [ $4 == "YES" ]
#then
#    echo "创建Demo"
#    sed -i '' 's/configurator.ask_with_answers(\"Would you like to include a demo application with your library\", \[\"Yes\", \"No\"\]).to_sym/yes/' ./setup/ConfigureSwift.rb
#    sed -i '' 's/configurator.ask_with_answers(\"Would you like to include a demo application with your library\", \[\"Yes\", \"No\"\]).to_sym/yes/' ./setup/ConfigureiOS.rb
#else
#    echo "不创建Demo"
#    sed -i '' 's/self.ask_with_answers(\"What language do you want to use?\", \[\"Swift\", \"ObjC\"\]).to_sym/no/' ./setup/ConfigureSwift.rb
#    sed -i '' 's/self.ask_with_answers(\"What language do you want to use?\", \[\"Swift\", \"ObjC\"\]).to_sym/no/' ./setup/ConfigureiOS.rb
#fi
#
#if [ $5 == 0 ]
#then
#    echo "Swift Use Quick"
#    sed -i '' 's/configurator.ask_with_answers(\"Which testing frameworks will you use\", \[\"Quick\", \"None\"\]).to_sym/quick/' ./setup/ConfigureSwift.rb
#
#    echo "OC Use Specta"
#    sed -i '' 's/configurator.ask_with_answers(\"Which testing frameworks will you use\", \[\"Specta\", \"Kiwi\", \"None\"\]).to_sym/specta/' ./setup/ConfigureiOS.rb
#elif [ $5 == 1]
#then
#    echo "Swift Use None"
#    sed -i '' 's/configurator.ask_with_answers(\"Which testing frameworks will you use\", \[\"Quick\", \"None\"\]).to_sym/none/' ./setup/ConfigureSwift.rb
#    echo "OC Use Kiwi"
#    sed -i '' 's/configurator.ask_with_answers(\"Which testing frameworks will you use\", \[\"Specta\", \"Kiwi\", \"None\"\]).to_sym/kiwi/' ./setup/ConfigureiOS.rb
#else
#echo "OC Use None"
#sed -i '' 's/configurator.ask_with_answers(\"Which testing frameworks will you use\", \[\"Specta\", \"Kiwi\", \"None\"\]).to_sym/none/' ./setup/ConfigureiOS.rb
#fi
#
#if [ $6 == "YES" ]
#then
#    echo "Swift View test"
#    sed -i '' 's/configurator.ask_with_answers(\"Would you like to do view based testing\", \[\"Yes\", \"No\"\]).to_sym/yes/' ./setup/ConfigureSwift.rb
#    echo "OC View test"
#    sed -i '' 's/configurator.ask_with_answers(\"Would you like to do view based testing\", \[\"Yes\", \"No\"\]).to_sym/yes/' ./setup/ConfigureiOS.rb
#
#else
#    echo "Swift No View test"
#    sed -i '' 's/configurator.ask_with_answers(\"Would you like to do view based testing\", \[\"Yes\", \"No\"\]).to_sym/yes/' ./setup/ConfigureSwift.rb
#    echo "OC No View test"
#    sed -i '' 's/configurator.ask_with_answers(\"Would you like to do view based testing\", \[\"Yes\", \"No\"\]).to_sym/yes/' ./setup/ConfigureiOS.rb
#fi

