package org;

import java.util.HashMap;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Utils {

    final private static Pattern pattern = Pattern.compile("^[1-9][0-9]{3}$");
    final private static HashMap<String, String> map = new HashMap<>(35);

    static {
        map.put("affiches", "Posters");
        map.put("posters", "Posters");
        map.put("ansichtkaarten", "Picture postcards");
        map.put("boeken", "Books");
        map.put("books", "Books");
        map.put("buttons", "Buttons");
        map.put("cassetteband", "Audiocassettes");
        map.put("cassettebanden", "Audiocassettes");
        map.put("cassettebandjes", "Audiocassettes");
        map.put("geluidscassettes", "Audiocassettes");
        map.put("audiocassettes", "Audiocassettes");
        map.put("audio cassettes", "Audiocassettes");
        map.put("cd-rom", "Compact discs");
        map.put("cds", "Compact discs");
        map.put("dias", "Slides");
        map.put("dvds", "DVDs");
        map.put("files", "Files");
        map.put("films", "Films");
        map.put("gb", "Gigabytes");
        map.put("glasdias", "Lantern slides");
        map.put("glasdia", "Lantern slides");
        map.put("glasnegatieven", "Glass negatives");
        map.put("mb", "Megabytes");
        map.put("microfiches", "Microfiches");
        map.put("microfilms", "Microfilms");
        map.put("microfilm", "Microfilms");
        map.put("negatieven", "Negatives (photographs)");
        map.put("objecten", "Objects");
        map.put("periodicals", "Periodicals");
        map.put("periodieken", "Periodicals");
        map.put("fotos", "Photographs");
        map.put("photos", "Photographs");
        map.put("prenten", "Prints");
        map.put("tekeningen", "Drawings");
        map.put("videocassettes", "Videocassettes");
        map.put("videobanden", "Videocassettes");
    }

    public static String unitdate(org.w3c.dom.NodeList nodelist) {

        int van = Integer.MAX_VALUE, tot = Integer.MIN_VALUE;

        final StringBuilder sb = new StringBuilder();

        for ( int i = 0 ; i < nodelist.getLength(); i++) {

            final String text = nodelist.item(i).getNodeValue();
            sb.append(text).append(" | ");

            final String str = text.replaceAll("[^\\d]", " ")
                    .trim()
                    .replaceAll(" +", " ");

            final String[] split = str.split(" ");
            for (String candidate : split) {
                final Matcher matcher = pattern.matcher(candidate);
                if (matcher.matches()) {
                    final int n = Integer.parseInt(candidate);
                    if (n < van) van = n;
                    if (n > tot) tot = n;
                }
            }
        }

        final String ret;
        if (van == Integer.MAX_VALUE && tot == Integer.MIN_VALUE) {
            System.out.println("No matches with " + sb);
            return null;
        } else if (van == Integer.MAX_VALUE) {
            ret = String.valueOf(tot);
        } else if (tot == Integer.MIN_VALUE) {
            ret = String.valueOf(van);
        } else {
            ret = van + "-" + tot;
        }

        return ret;
    }

    public static String normalDate(String text) {
        return text.replaceAll("-", "");
    }
    
    public static String extent(String _text) {
        final String text = _text.replace("'", "").replace("’", "").toLowerCase();

        final StringBuilder sb = new StringBuilder();

        final String[] keys = text.split(" ");
        for (String key : keys) {
            final String value = map.get(key);
            if ( value == null ) {
                sb.append(key);
            } else {
                sb.append(value);
            }
            sb.append(" ");
        }

        return sb.toString().trim();
    }
}
