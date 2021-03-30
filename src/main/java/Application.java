import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.security.SecurityAutoConfiguration;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.boot.web.servlet.ErrorPage;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.http.HttpStatus;
import org.springframework.transaction.annotation.EnableTransactionManagement;


@SpringBootApplication
@MapperScan("com.haitong.youcai.mapper")
@ComponentScan(basePackages = { "com.haitong.youcai.config", "com.haitong.youcai.entity", "com.haitong.youcai.service","com.haitong.youcai.mapper","com.haitong.youcai.controller"})
@EnableCaching
@EnableTransactionManagement
public class Application {
	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

	/**
	 * 自定义异常页
	 */
	@Bean
	public EmbeddedServletContainerCustomizer containerCustomizer() {

		return (container -> {
			ErrorPage error401Page = new ErrorPage(HttpStatus.FORBIDDEN, "/WEB-INF/jsp/404.jsp");
			ErrorPage error404Page = new ErrorPage(HttpStatus.NOT_FOUND, "/WEB-INF/jsp/404.jsp");
			ErrorPage error500Page = new ErrorPage(HttpStatus.INTERNAL_SERVER_ERROR, "/WEB-INF/jsp/404.jsp");
			container.addErrorPages(error401Page, error404Page, error500Page);
		});
	}
}
