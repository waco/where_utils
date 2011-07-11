module WhereUtils #:nodoc:
  KANA_KEYS = [
    { :key => 'a',  :name => 'あ行', :value => ['あ','い','う','え','お'] },
    { :key => 'ka', :name => 'か行', :value => ['か','き','く','け','こ','が','ぎ','ぐ','げ','ご'] },
    { :key => 'sa', :name => 'さ行', :value => ['さ','し','す','せ','そ','ざ','じ','ず','ぜ','ぞ'] },
    { :key => 'ta', :name => 'た行', :value => ['た','ち','つ','て','と','だ','ぢ','づ','で','ど'] },
    { :key => 'na', :name => 'な行', :value => ['な','に','ぬ','ね','の'] },
    { :key => 'ha', :name => 'は行', :value => ['は','ひ','ふ','へ','ほ','ば','び','ぶ','べ','ぼ','ぱ','ぴ','ぷ','ぺ','ぽ'] },
    { :key => 'ma', :name => 'ま行', :value => ['ま','み','む','め','も'] },
    { :key => 'ya', :name => 'や行', :value => ['や','ゆ','よ'] },
    { :key => 'ra', :name => 'ら行', :value => ['ら','り','る','れ','ろ'] },
    { :key => 'wa', :name => 'わ行', :value => ['わ','を','ん'] },
    { :key => '', :name => 'すべて', :value => [] }
  ]

  def self.included(base) #:nodoc:
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    # add conditions of kana from kana-key (kana-key can be refered to KANA_KEYS)
    #
    # == Configration options
    #
    # *<tt>column</tt> - column to find
    # *<tt>kana</tt> - specify kana-key from KANA_KEYS
    #
    # Examples:
    #
    #  Book.where_kana(:kana, params[:kana]).all
    #
    def where_kana(column, kana)
      model = self
      kana_keys = KANA_KEYS.inject({}){ |r, k| r[k[:key]] = k[:value] unless k[:key].blank?; r }
      keys = kana_keys[kana] || ''
      unless keys.blank?
        conditions = { :query => [], :params => [] }
        keys.each do |k|
          conditions[:query] << "#{column} LIKE ?"
          conditions[:params] << "#{k}%"
        end
        model = model.where(conditions[:query].join(' OR '), *conditions[:params])
      end

      model
    end
  end

  module InstanceMethods
  end
end
