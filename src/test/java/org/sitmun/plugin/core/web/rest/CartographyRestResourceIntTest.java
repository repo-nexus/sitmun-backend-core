package org.sitmun.plugin.core.web.rest;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.sitmun.plugin.core.security.SecurityConstants.HEADER_STRING;
import static org.sitmun.plugin.core.security.SecurityConstants.TOKEN_PREFIX;
import static org.sitmun.plugin.core.test.TestConstants.SITMUN_ADMIN_USERNAME;
import static org.sitmun.plugin.core.test.TestUtils.withMockSitmunAdmin;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


import java.math.BigInteger;
import java.net.URI;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.sitmun.plugin.core.config.RepositoryRestConfig;
import org.sitmun.plugin.core.domain.Cartography;
import org.sitmun.plugin.core.domain.CartographyAvailability;
import org.sitmun.plugin.core.domain.Service;
import org.sitmun.plugin.core.domain.Territory;
import org.sitmun.plugin.core.repository.CartographyAvailabilityRepository;
import org.sitmun.plugin.core.repository.CartographyRepository;
import org.sitmun.plugin.core.repository.ServiceRepository;
import org.sitmun.plugin.core.repository.TerritoryRepository;
import org.sitmun.plugin.core.security.TokenProvider;
import org.sitmun.plugin.core.test.TestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.data.rest.webmvc.config.RepositoryRestConfigurer;
import org.springframework.hateoas.MediaTypes;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.validation.Validator;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

@RunWith(SpringRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
public class CartographyRestResourceIntTest {

  private static final String CARTOGRAPHY_NAME = "Cartography Name";
  private static final String CARTOGRAPHY_URI = "http://localhost/api/cartographies";
  @Autowired
  private CartographyRepository cartographyRepository;
  @Autowired
  private CartographyAvailabilityRepository cartographyAvailabilityRepository;
  @Autowired
  private TokenProvider tokenProvider;
  @Autowired
  private TerritoryRepository territoryRepository;
  @Autowired
  private ServiceRepository serviceRepository;
  @Autowired
  private MockMvc mvc;

  private String token;
  private Territory territory;
  private Cartography cartography;
  private Service service;
  private ArrayList<Cartography> cartographies;
  private ArrayList<CartographyAvailability> availabilities;

  @Before
  public void init() {

    withMockSitmunAdmin(() -> {

      token = tokenProvider.createToken(SITMUN_ADMIN_USERNAME);

      territory = Territory.builder()
          .setName("Territorio 1")
          .setCode("")
          .setBlocked(false)
          .build();
      territoryRepository.save(territory);

      service = new Service();
      service.setName("Service");
      service.setServiceURL("");
      service.setType("");
      serviceRepository.save(service);

      cartographies = new ArrayList<>();
      availabilities = new ArrayList<>();

      cartography = Cartography.builder()
          .setName(CARTOGRAPHY_NAME)
          .setLayers(Collections.emptyList())
          .setApplyFilterToGetMap(false)
          .setApplyFilterToGetFeatureInfo(false)
          .setApplyFilterToSpatialSelection(false)
          .setService(service)
          .setAvailabilities(Collections.emptySet())
          .build();
      cartographies.add(cartography);

      Cartography cartographyWithAvailabilities = Cartography.builder()
          .setName("Cartography with availabilities")
          .setLayers(Collections.emptyList())
          .setApplyFilterToGetMap(false)
          .setApplyFilterToGetFeatureInfo(false)
          .setApplyFilterToSpatialSelection(false)
          .setService(service)
          .setAvailabilities(Collections.emptySet())
          .build();

      cartographies.add(cartographyWithAvailabilities);

      cartographyRepository.saveAll(cartographies);
      CartographyAvailability cartographyAvailability1 = new CartographyAvailability();
      cartographyAvailability1.setCartography(cartographyWithAvailabilities);
      cartographyAvailability1.setTerritory(territory);
      cartographyAvailability1.setCreatedDate(new Date());
      availabilities.add(cartographyAvailability1);

      cartographyAvailabilityRepository.saveAll(availabilities);
    });
  }

  @After
  public void after() {
    withMockSitmunAdmin(() -> {
      cartographyAvailabilityRepository.deleteAll(availabilities);
      cartographyRepository.deleteAll(cartographies);
      serviceRepository.delete(service);
      territoryRepository.delete(territory);
    });
  }

  @Test
  @WithMockUser(username = SITMUN_ADMIN_USERNAME)
  public void postCartography() throws Exception {

    String content = new JSONObject()
        .put("name", CARTOGRAPHY_NAME)
        .put("layers", new JSONArray())
        .put("applyFilterToGetMap", false)
        .put("applyFilterToSpatialSelection", false)
        .put("applyFilterToGetFeatureInfo", false)
        .put("service", "http://localhost/api/services/" + service.getId())
        .toString();

    String location = mvc.perform(post(CARTOGRAPHY_URI)
        .header(HEADER_STRING, TOKEN_PREFIX + token)
        .contentType(MediaType.APPLICATION_JSON)
        .content(content)
    ).andExpect(status().isCreated())
        .andReturn().getResponse().getHeader("Location");

    assertThat(location, notNullValue());

    mvc.perform(get(location)
        .header(HEADER_STRING, TOKEN_PREFIX + token))
        .andExpect(status().isOk())
        .andExpect(content().contentType(MediaTypes.HAL_JSON))
        .andExpect(jsonPath("$.name", equalTo(CARTOGRAPHY_NAME)));

    withMockSitmunAdmin(() -> {
      String[] paths = URI.create(location).getPath().split("/");
      BigInteger id = BigInteger.valueOf(Integer.parseInt(paths[paths.length - 1]));
      cartographyRepository.findById(id).ifPresent((it) -> cartographies.add(it));
    });
  }

  @Test
  public void getCartographiesAsPublic() throws Exception {
    mvc.perform(get(CARTOGRAPHY_URI))
        .andDo(print())
        .andExpect(status().isOk());
  }

  @Test
  public void postCartographyAsPublicUserFails() throws Exception {
    mvc.perform(post(CARTOGRAPHY_URI)
        .contentType(MediaType.APPLICATION_JSON)
        .content(TestUtils.asJsonString(cartography)))
        .andDo(print()).andExpect(status().is4xxClientError()).andReturn();
  }

  @TestConfiguration
  static class ContextConfiguration {
    @Bean
    public Validator validator() {
      return new LocalValidatorFactoryBean();
    }

    @Bean
    RepositoryRestConfigurer repositoryRestConfigurer() {
      return new RepositoryRestConfig(validator());
    }
  }

}
