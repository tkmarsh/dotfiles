
alias ob="vim ~/.bashrc"
alias sb=". ~/.bashrc"
alias gccpre="g++ -E -dM - </dev/null"
alias tmux="tmux -2"

alias antlr4='java -jar /usr/local/lib/antlr-4.1-complete.jar'
alias grun='java org.antlr.v4.runtime.misc.TestRig'

alias forge='java -jar /opt/maven/vulcan/forge/0.0.1-SNAPSHOT/forge-0.0.1-SNAPSHOT.jar'
alias catalyst='python -m catalyst.main'
alias forge_nysetrades='forge -o ~/work/vulcan/catalyst/design/test.xml -r ~/work/vulcan/forge/resources/ -p ~/work/vulcan/vsl/packages/ -v ~/work/vulcan/vsl/products/nysetradesxdp/nysetradesxdp.vsl -l -x ~/work/vulcan/forge/resources/product-definition-fh.xsd -c false'
alias forge_build='cd ~/work/vulcan/forge/; mvn -Dmaven.repo.local=/opt/maven/ -DskipTests -Dregenerate install; cd -'
