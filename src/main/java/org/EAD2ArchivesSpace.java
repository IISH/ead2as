package org;

import org.xml.sax.SAXException;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;

public class EAD2ArchivesSpace {


    final TransformerFactory tf = TransformerFactory.newInstance();
    @SuppressWarnings("unchecked")
    private ArrayList<Transformer> transformers = new ArrayList(2);
    private static Validate validate;

    private EAD2ArchivesSpace() {

        try {
            validate = new Validate();
        } catch (SAXException e) {
            e.printStackTrace();
        }

        String[] _transformers = {"/ar-1.xsl"};
//        String[] _transformers = {"/ar-2.xsl", "/ar-12.xsl", "/ar-20.xsl"}; // lwo
//        String[] _transformers = { "/ar-3.xsl", "/ar-11.xsl", "/ar-21.xsl", "/ar-24.xsl", "/ar-22-temove-empty-nodes.xsl" }; // gcu
//        String[] _transformers = {"/ar-29.xsl"}; // gcu

        //
        for (String _transformer : _transformers) {

            final URL resource = this.getClass().getResource(_transformer);
            Source source = null;
            try {
                source = new StreamSource(resource.openStream());
            } catch (IOException e) {
                System.err.println(e.getMessage());
                System.exit(-1);
            }

            source.setSystemId(resource.toString());
            try {
                transformers.add(tf.newTransformer(source));
            } catch (TransformerConfigurationException e) {
                System.err.println(e.getMessage());
                System.exit(-1);
            }
        }

    }

    private void run(String source_folder, String target_folder) throws IOException, TransformerException {

        final File[] source_files = new File(source_folder).listFiles();
        if (source_files == null) {
            System.out.print("The folder has no files: " + source_folder);
            System.exit(-1);
        }

        final File targetFolder = new File(target_folder);
        if (!targetFolder.exists() && !targetFolder.mkdirs()) {
            System.out.print("Failed to create folder " + target_folder);
            System.exit(-1);
        }

        for (File source_file : source_files) {
            final FileInputStream source = new FileInputStream(source_file);
            final FilterInputStream fis = new BufferedInputStream(source);

            final int length = (int) source_file.length();
            byte[] tmp = new byte[length];

            // Filter herhaling in tab, linefeet en carriage return combinaties.
            int b, index = -1;
            boolean repeat = false;
            while ((b = fis.read()) != -1) {
                switch (b) {
                    case 9: // tab
                    case 10: // linefeed
                    case 13: // carriage return
                    case 32: //space
                        if (repeat) {
                            // skip
                        } else {
                            tmp[++index] = 32; // space
                            repeat = true;
                        }
                        break;
                    default:
                        repeat = false;
                        tmp[++index] = (byte) b;
                }
            }

            final int l = index + 1;
            final String name = source_file.getName();
            byte[] record = Arrays.copyOfRange(tmp, 0, l);

            System.out.println(source_file.getAbsolutePath() + " " + l + " " + name);
            for (Transformer transformer : transformers) {
                record = convertRecord(transformer, record);
            }

            final File target = new File(targetFolder, name);
            final FileOutputStream fos = new FileOutputStream(target);
            fos.write(record);

            final String msg = validate.validate(target);
            if (msg != null) {
                System.out.println("Invalid EAD xml document: " + target.getAbsolutePath());
                System.out.println(msg);
            }
        }
    }

    private byte[] convertRecord(Transformer transformer, byte[] record) throws TransformerException {

        final StreamSource source = new StreamSource(new ByteArrayInputStream(record));
        final ByteArrayOutputStream baos = new ByteArrayOutputStream();
        transformer.transform(source, new StreamResult(baos));
        return baos.toByteArray();
    }

    /**
     * main
     *
     * @param args 0=source folder; 1=destination folder
     */
    public static void main(String[] args) throws IOException, TransformerException {

        final String in = args[0];
        final String out = args[1];

        System.out.println("In " + in);
        System.out.println("Out " + out);
        new EAD2ArchivesSpace().run(in, out);
    }
}
