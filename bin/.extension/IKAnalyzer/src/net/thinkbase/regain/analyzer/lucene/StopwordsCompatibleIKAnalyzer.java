package net.thinkbase.regain.analyzer.lucene;

import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.apache.lucene.analysis.StopwordAnalyzerBase;
import org.apache.lucene.analysis.Tokenizer;
import org.apache.lucene.analysis.cjk.CJKAnalyzer;
import org.apache.lucene.util.Version;
import org.wltea.analyzer.cfg.DefaultConfig;
import org.wltea.analyzer.dic.Dictionary;
import org.wltea.analyzer.lucene.IKAnalyzer;
import org.wltea.analyzer.lucene.IKTokenizer;

/**
 * 兼容 regain Stopword 设置的 IKAnalyzer, 参考 {@link IKAnalyzer} 及 {@link CJKAnalyzer};
 * <br/>
 * <b>注意: </b>本实现默认使用 {@link DefaultConfig} 指定的扩展停止字典.
 * 
 * @author thinkbase.net
 */
public class StopwordsCompatibleIKAnalyzer extends StopwordAnalyzerBase{	
	protected StopwordsCompatibleIKAnalyzer(Version version) {
		super(version);
		addStopwords();
	}
	public StopwordsCompatibleIKAnalyzer(Version version, Set<?> stopwords) {
		super(version, stopwords);
		addStopwords();
	}
	
	static{
		Dictionary.initial(DefaultConfig.getInstance());
	}
	private void addStopwords(){
		if (null!=this.stopwords){
			List<String> swList = new ArrayList<String>();
			for (Object sw: this.stopwords){
				char[] c = (char[]) sw;
				String s = new String(c);
				swList.add(s);
			}
			Dictionary.getSingleton().addWords(swList);
		}
	}

	@Override
	protected TokenStreamComponents createComponents(String fieldName, Reader reader) {
		Tokenizer t = new IKTokenizer(reader , this.useSmart());
		TokenStreamComponents tc = new TokenStreamComponents(t);
		return tc;
	}
	
	private boolean useSmart(){
		return DefaultConfig.getInstance().useSmart();
	}
}
